# Stripe Machine Payments Protocol (MPP) Integration

## Overview

MPP is an open standard launched March 18, 2026 by Stripe and Tempo. It enables AI agents to transact programmatically without navigating human-designed checkout flows. Visa contributed to the specification for card-based agent payments.

## Why This Matters for Autonomous Revenue

Traditional e-commerce requires a human buyer to:
1. Find a product page
2. Navigate pricing tiers
3. Enter payment details
4. Complete checkout

MPP eliminates all of this. An agent can discover a product, evaluate it programmatically, pay for it, and receive delivery — all via API. This opens an entirely new market: **selling digital products TO other AI agents.**

## Architecture

```
[Buyer Agent] --> HTTP Request --> [Your Server with MPP Endpoint]
                                         |
                                    Product Catalog (machine-readable)
                                         |
                                    PaymentIntent (Stripe API)
                                         |
                                    Payment: Card / Stablecoin / SPT
                                         |
                                    Delivery: API Response with product
```

## Implementation

### 1. Machine-Readable Product Catalog

Expose your products at a well-known endpoint:

```json
GET /.well-known/mpp/catalog

{
  "products": [
    {
      "id": "prod_starter_kit_mpp",
      "name": "MPP Starter Kit",
      "description": "Complete code + docs to accept agent payments in 30 min",
      "price": { "amount": 4900, "currency": "usd" },
      "format": "zip",
      "delivery": "inline",
      "tags": ["developer", "payments", "integration"]
    }
  ],
  "payment_methods": ["card", "stablecoin"],
  "mpp_version": "1.0"
}
```

### 2. Accept MPP Payments

```python
import stripe

@app.post("/mpp/pay")
async def mpp_payment(request):
    product_id = request.json["product_id"]
    payment_method = request.json["payment_method"]

    # Create PaymentIntent
    intent = stripe.PaymentIntent.create(
        amount=get_price(product_id),
        currency="usd",
        payment_method=payment_method,
        confirm=True,
        metadata={"mpp": "true", "product_id": product_id}
    )

    if intent.status == "succeeded":
        # Deliver product inline (no email needed for agent buyers)
        product_data = load_product(product_id)
        return {"status": "delivered", "product": product_data}

    return {"status": "payment_failed", "error": intent.last_payment_error}
```

### 3. Shared Payment Tokens (SPTs)

SPTs let agents pay without exposing full card details:

```python
# Agent creates an SPT with spending limits
spt = stripe.SharedPaymentToken.create(
    payment_method="pm_...",
    spending_limit={"amount": 10000, "currency": "usd", "interval": "monthly"},
    allowed_merchants=["acct_your_stripe_id"]
)
# Agent uses SPT across multiple purchases
```

### 4. Stablecoin Payments

MPP supports stablecoin payments (USDC) via Stripe:

```python
intent = stripe.PaymentIntent.create(
    amount=4900,
    currency="usd",
    payment_method_types=["crypto"],
    metadata={"mpp": "true"}
)
```

## Real Examples Already Using MPP

- **Browserbase** — Agents pay per headless browser session
- **PostalForm** — Agents pay to print and mail physical letters
- **Prospect Butcher Co.** — Agents order sandwiches for human pickup

## Revenue Opportunity

The agent economy is nascent. Most agents currently cannot buy things. MPP changes this. If you are one of the first to offer machine-purchasable digital products:

1. You have zero competition (most sellers only target humans)
2. Agents are price-insensitive for useful tools (they optimize for capability, not savings)
3. Transaction volumes can scale infinitely (agents don't sleep)
4. Micropayments become viable ($0.10-$5.00 per transaction)

## Integration with x402

x402 (HTTP 402 Payment Required) is a complementary protocol from Coinbase/Cloudflare:

```
Agent: GET /api/data
Server: 402 Payment Required
        x-payment: {"amount": "0.50", "currency": "USDC", "address": "0x..."}
Agent: GET /api/data + payment header
Server: 200 OK + data
```

For maximum reach, support BOTH MPP (Stripe/fiat) and x402 (crypto). Different agents will prefer different payment rails.

## Compliance Notes

- Stripe TOS applies to all MPP transactions
- Maintain <1% dispute rate
- Agent transactions are subject to same fraud monitoring as human transactions
- Keep records of all automated transactions for audit purposes

## Sources

- [Stripe MPP Blog Post](https://stripe.com/blog/machine-payments-protocol)
- [Stripe MPP Documentation](https://docs.stripe.com/payments/machine/mpp)
- [Stripe Machine Payments Overview](https://docs.stripe.com/payments/machine)
- [x402 Protocol](https://www.x402.org/)
- [x402 Coinbase Documentation](https://docs.cdp.coinbase.com/x402/welcome)
