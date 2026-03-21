#!/usr/bin/env bash
# revenue-report.sh — Stripe revenue analytics for autonomous products
# Usage: ./revenue-report.sh [--days 30] [--product prod_xxx]
#
# Pulls sales data from Stripe API and generates performance report.
# Requires STRIPE_SECRET_KEY in environment.

set -euo pipefail

DAYS=30
PRODUCT_FILTER=""
OUTPUT_DIR="/tmp/autonomous-revenue/reports"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --days) DAYS="$2"; shift 2;;
        --product) PRODUCT_FILTER="$2"; shift 2;;
        *) shift;;
    esac
done

mkdir -p "$OUTPUT_DIR"

# Validate Stripe key
if [[ -z "${STRIPE_SECRET_KEY:-}" ]]; then
    echo "ERROR: STRIPE_SECRET_KEY not set"
    echo "Export it: export STRIPE_SECRET_KEY='sk_live_...'"
    exit 1
fi

SINCE=$(date -u -d "$DAYS days ago" +%s 2>/dev/null || date -u -v-${DAYS}d +%s 2>/dev/null || echo "0")
REPORT_FILE="$OUTPUT_DIR/revenue_$(date +%Y%m%d).json"

echo "=== AUTONOMOUS REVENUE REPORT ==="
echo "Period: Last $DAYS days"
echo "Generated: $TIMESTAMP"
echo ""

# --- Fetch charges from Stripe ---
echo "Fetching Stripe data..."

CHARGES_FILE="$OUTPUT_DIR/charges_raw.json"
curl -s -u "$STRIPE_SECRET_KEY:" \
    "https://api.stripe.com/v1/charges?created[gte]=$SINCE&limit=100&expand[]=data.balance_transaction" \
    -o "$CHARGES_FILE"

if [[ ! -f "$CHARGES_FILE" ]] || ! jq -e '.data' "$CHARGES_FILE" &>/dev/null; then
    echo "ERROR: Failed to fetch Stripe data. Check API key."
    exit 1
fi

# --- Fetch products ---
PRODUCTS_FILE="$OUTPUT_DIR/products_raw.json"
curl -s -u "$STRIPE_SECRET_KEY:" \
    "https://api.stripe.com/v1/products?limit=100&active=true" \
    -o "$PRODUCTS_FILE"

# --- Fetch refunds ---
REFUNDS_FILE="$OUTPUT_DIR/refunds_raw.json"
curl -s -u "$STRIPE_SECRET_KEY:" \
    "https://api.stripe.com/v1/refunds?created[gte]=$SINCE&limit=100" \
    -o "$REFUNDS_FILE"

# --- Generate report ---
python3 << 'PYTHON_REPORT'
import json
import sys
from datetime import datetime, timedelta
from collections import defaultdict

def load_json(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"data": []}

charges = load_json("/tmp/autonomous-revenue/reports/charges_raw.json")
products = load_json("/tmp/autonomous-revenue/reports/products_raw.json")
refunds = load_json("/tmp/autonomous-revenue/reports/refunds_raw.json")

# Process charges
total_revenue = 0
total_fees = 0
total_net = 0
charge_count = 0
product_revenue = defaultdict(lambda: {"revenue": 0, "sales": 0, "refunds": 0})
daily_revenue = defaultdict(int)

for charge in charges.get("data", []):
    if charge.get("status") != "succeeded":
        continue

    amount = charge.get("amount", 0) / 100  # cents to dollars
    total_revenue += amount
    charge_count += 1

    # Get balance transaction for fees
    bt = charge.get("balance_transaction", {})
    if isinstance(bt, dict):
        total_fees += bt.get("fee", 0) / 100
        total_net += bt.get("net", 0) / 100

    # Track by product (from metadata or invoice)
    prod_id = charge.get("metadata", {}).get("product_id", "unknown")
    product_revenue[prod_id]["revenue"] += amount
    product_revenue[prod_id]["sales"] += 1

    # Daily tracking
    day = datetime.fromtimestamp(charge["created"]).strftime("%Y-%m-%d")
    daily_revenue[day] += amount

# Process refunds
total_refunds = 0
refund_count = 0
for refund in refunds.get("data", []):
    amount = refund.get("amount", 0) / 100
    total_refunds += amount
    refund_count += 1

    prod_id = refund.get("metadata", {}).get("product_id", "unknown")
    product_revenue[prod_id]["refunds"] += 1

# Build product catalog
product_names = {}
for prod in products.get("data", []):
    product_names[prod["id"]] = prod.get("name", prod["id"])

# Calculate metrics
avg_order = total_revenue / charge_count if charge_count > 0 else 0
refund_rate = (refund_count / charge_count * 100) if charge_count > 0 else 0
daily_avg = total_revenue / max(len(daily_revenue), 1)

# Print report
print("=" * 60)
print("REVENUE SUMMARY")
print("=" * 60)
print(f"  Gross Revenue:    ${total_revenue:,.2f}")
print(f"  Stripe Fees:      ${total_fees:,.2f}")
print(f"  Refunds:          ${total_refunds:,.2f} ({refund_count} refunds)")
print(f"  Net Revenue:      ${total_net - total_refunds:,.2f}")
print(f"  Total Sales:      {charge_count}")
print(f"  Avg Order Value:  ${avg_order:,.2f}")
print(f"  Refund Rate:      {refund_rate:.1f}%")
print(f"  Daily Average:    ${daily_avg:,.2f}")
print()

# Product breakdown
print("=" * 60)
print("PRODUCT PERFORMANCE")
print("=" * 60)
for prod_id, data in sorted(product_revenue.items(), key=lambda x: x[1]["revenue"], reverse=True):
    name = product_names.get(prod_id, prod_id)
    conv_note = ""
    if data["refunds"] > 0:
        prod_refund_rate = data["refunds"] / data["sales"] * 100
        if prod_refund_rate > 10:
            conv_note = " *** HIGH REFUND RATE - REVIEW ***"
    print(f"  {name}")
    print(f"    Revenue: ${data['revenue']:,.2f} | Sales: {data['sales']} | Refunds: {data['refunds']}{conv_note}")
print()

# Daily trend
print("=" * 60)
print("DAILY REVENUE (last 14 days)")
print("=" * 60)
for day in sorted(daily_revenue.keys())[-14:]:
    bar = "#" * int(daily_revenue[day] / max(daily_avg, 1) * 10)
    print(f"  {day}: ${daily_revenue[day]:>8,.2f} {bar}")
print()

# Alerts
print("=" * 60)
print("ALERTS")
print("=" * 60)
if refund_rate > 10:
    print("  [!!!] Refund rate above 10% — investigate product quality")
if refund_rate > 5:
    print("  [!!]  Refund rate above 5% — monitor closely")
if charge_count == 0:
    print("  [!]   No sales in period — review pricing and distribution")
if daily_avg < 1 and charge_count > 0:
    print("  [!]   Daily average below $1 — consider new products or verticals")
if len(product_revenue) < 3:
    print("  [i]   Fewer than 3 products — expand catalog for diversification")

# Forecast
monthly_projected = daily_avg * 30
print()
print("=" * 60)
print("FORECAST")
print("=" * 60)
print(f"  30-day projection:  ${monthly_projected:,.2f}")
print(f"  90-day projection:  ${monthly_projected * 3:,.2f} (assumes flat growth)")
print(f"  Target ($500/mo):   {'ON TRACK' if monthly_projected >= 500 else f'Need ${500 - monthly_projected:,.2f} more/mo'}")

# Save structured report
report = {
    "generated": datetime.utcnow().isoformat() + "Z",
    "period_days": len(daily_revenue),
    "gross_revenue": total_revenue,
    "net_revenue": total_net - total_refunds,
    "fees": total_fees,
    "refunds": total_refunds,
    "sales_count": charge_count,
    "refund_count": refund_count,
    "refund_rate": refund_rate,
    "avg_order_value": avg_order,
    "daily_average": daily_avg,
    "products": {k: v for k, v in product_revenue.items()},
    "daily": dict(daily_revenue),
    "forecast_30d": monthly_projected
}

with open("/tmp/autonomous-revenue/reports/revenue_latest.json", "w") as f:
    json.dump(report, f, indent=2)

print()
print(f"Full report: /tmp/autonomous-revenue/reports/revenue_latest.json")
PYTHON_REPORT

echo ""
echo "=== Report Complete ==="
