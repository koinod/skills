# Deep Research Lite

Structured research skill for Claude Code / OpenClaw agents. Produces source-backed, confidence-scored research reports with actionable output.

## What's Included

- **Market Research** mode — competitive landscape, pricing, TAM/SAM/SOM, customer needs
- **Technical Research** mode — architecture, benchmarks, tradeoffs, failure modes
- **3-tier source evaluation** — HIGH / MEDIUM / LOW credibility scoring
- **Convergence mapping** — find where sources agree, disagree, and form patterns
- **Confidence scoring** — every finding tagged HIGH / MEDIUM / LOW
- **Structured reports** — executive summary, evidence map, implications, action items

## Usage

```
/research market "AI video editing SaaS for agencies"
/research technical "WebRTC vs HLS for live streaming under 500ms latency"
```

## Installation

Copy `SKILL.md` into your agent's skills directory or reference it in your OpenClaw config.

## Full Version

The full Deep Research skill at **koino.capital/kits** adds:

| Feature | Lite | Full |
|---------|------|------|
| Research modes | 2 (Market, Technical) | 6 (+People, Trend, Risk, Alpha) |
| Source scoring | 3-tier (H/M/L) | CRAAP+ 25-point framework |
| Synthesis | Convergence mapping | 8 patterns (Tension, Absence, Incentive, etc.) |
| Blind spot detection | -- | Yes |
| Contrarian analysis | -- | Yes |
| OSINT frameworks | -- | Bellingcat methods |
| CI methods | -- | Hedge fund competitive intelligence |
| Temporal analysis | -- | Yes |
| Network analysis | -- | Yes |
| Depth levels | Quick, Standard | Quick, Standard, Exhaustive |

Get the full version at **https://koino.capital/kits**

## License

Free to use and distribute. Built by KOINO Capital.
