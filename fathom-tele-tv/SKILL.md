# SKILL.md - Fathom/Tele.tv Integration

This skill enables integration with Fathom and Tele.tv for call and video recording analysis.

## Setup

1. Install Fathom CLI if available:
   ```bash
   brew install fathom
   ```

2. Install Tele.tv CLI if available:
   ```bash
   brew install tele-tv
   ```

## Usage

### Fathom Integration
- List recordings: `fathom recordings list --status "completed"`
- Get recording details: `fathom recordings get <id>`
- Transcribe recording: `fathom recordings transcribe <id>`
- Extract insights: `fathom insights extract <id> --focus "sales"`

### Tele.tv Integration
- List videos: `tele-tv videos list --status "processed"`
- Get video details: `tele-tv videos get <id>`
- Analyze content: `tele-tv analysis run <id> --type "engagement"`
- Extract clips: `tele-tv clips extract <id> --duration "30s"`

### Content Processing
- Process recordings for ad content: `utari ai process <file> --type "call-analysis"`
- Generate ad scripts from insights: `utari ads create --insights <insights>`
- Create content summaries: `utari ai summarize <length> <content>`

## Integration with Workflow

1. Use Fathom/Tele.tv to record calls and videos
2. Use this skill to extract insights and content
3. Feed insights into Utari for ad script generation
4. Use Brand Operator to organize and store processed content
5. Use gog to manage Google Drive storage

## Notes

- Integration depends on API access to Fathom/Tele.tv
- Content extraction focuses on actionable insights
- Call analysis identifies sales objections, pain points, and wins
- Video analysis identifies engagement patterns and key moments
- Processed content feeds into the ad creation pipeline