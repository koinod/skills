# SKILL.md - Brand Operator Integration

This skill enables integration with Brand Operator for marketing automation and content management.

## Setup

1. Install Brand Operator CLI if not already installed:
   ```bash
   brew install brand-operator
   ```

2. Authenticate with Brand Operator:
   ```bash
   brand-operator auth login
   ```

## Usage

### Content Management
- Search content library: `brand-operator content search "query"`
- Get content details: `brand-operator content get <id>`
- Upload new content: `brand-operator content upload <file>`

### Campaign Management
- List campaigns: `brand-operator campaigns list`
- Create campaign: `brand-operator campaigns create --name "name" --type "type"`
- Get campaign details: `brand-operator campaigns get <id>`

### Analytics
- Get performance metrics: `brand-operator analytics get <campaignId>`
- Generate reports: `brand-operator reports generate <campaignId>`

## Integration with Existing Workflow

This skill works alongside gog (Google Workspace) and other marketing tools to provide a complete content-to-campaign pipeline.

## Notes

- Brand Operator requires API credentials for full functionality
- Content search uses semantic matching and metadata
- Campaign creation supports templates for different ad formats
- Analytics integrates with Google Analytics and ad platform APIs