# SKILL.md - Utari Integration

This skill enables integration with Utari for ad scripting and AI-powered content creation.

## Setup

1. Install Utari CLI if not already installed:
   ```bash
   brew install utari
   ```

2. Authenticate with Utari:
   ```bash
   utari auth login
   ```

## Usage

### Ad Scripting
- Generate ad scripts: `utari ads create --product "product" --audience "audience" --tone "tone"`
- Get script templates: `utari ads templates`
- Customize scripts: `utari ads edit <id> --text "new text"`

### Content Ideation
- Brainstorm ideas: `utari ideas brainstorm --topic "topic" --platform "platform"`
- Get trending topics: `utari trends current`
- Analyze competitors: `utari competitors analyze <url>`

### AI Processing
- Process recordings: `utari ai process <recording> --type "transcription"`
- Extract insights: `utari ai insights <content> --focus "focus"`
- Generate summaries: `utari ai summarize <length> content>`

## Integration with Existing Workflow

Utari works with Brand Operator and gog to create a seamless content-to-ad pipeline:

1. Use Brand Operator to find existing content
2. Use Utari to generate ad scripts from that content
3. Use gog to manage Google Drive storage and sharing
4. Use Utari AI to process call recordings from Fathom/Tele.tv

## Notes

- Utari requires API credentials for full functionality
- Ad scripts support multiple formats (video, audio, text)
- AI processing supports various file types (mp3, mp4, txt, pdf)
- Integration with Fathom/Tele.tv for call analysis
- Content scoring system for ad performance prediction