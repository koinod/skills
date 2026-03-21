# SKILL.md - Ad-First Marketing Engine

This skill focuses on ad creation and optimization while respecting organic posting constraints.

## Current Strategy

**Primary Focus:** Ads (15x ROAS baseline)
**Organic Constraint:** Manual posting preferred by algorithm
**Goal:** Scale ad performance while building organic foundation

## Ad Creation Workflow

### 1. Content Discovery & Processing
- **Google Drive Scan:** `gog drive search "type:video OR type:audio" --max 100`
- **Content Analysis:** `brand-operator content analyze <file> --focus "ad-potential"`
- **Call Insights:** `fathom-tele-tv insights <recordings> --type "ad-content"`
- **Content Scoring:** `utari ai score <content> --criteria "ad-quality"`

### 2. Ad Script Generation
- **Script Creation:** `utari ads create --product "Bryson's offer" --insights <insights>`
- **Tone Customization:** `utari ads edit <id> --tone "conversational"`
- **Platform Optimization:** `utari ads optimize <id> --platform "facebook"`
- **A/B Variations:** `utari ads variations <id> --count 5`

### 3. Campaign Management
- **Campaign Setup:** `brand-operator campaigns create --name "Campaign Name" --type "ads"`
- **Ad Assignment:** `brand-operator campaigns add <campaignId> <ads>`
- **Targeting Setup:** `brand-operator campaigns target <campaignId> --audience "target-audience"`
- **Budget Allocation:** `brand-operator campaigns budget <campaignId> --amount "1000"`

### 4. Performance Tracking
- **ROAS Monitoring:** `brand-operator analytics roas <campaignId>`
- **Engagement Metrics:** `brand-operator analytics engagement <campaignId>`
- **Conversion Tracking:** `brand-operator analytics conversions <campaignId>`
- **Optimization Alerts:** `brand-operator campaigns alerts <campaignId>`

## Organic Content Strategy

### Content Preparation (for manual posting)
- **Content Categorization:** `brand-operator content categorize <content>`
- **Hashtag Research:** `utari trends hashtags --topic "Bryson's niche"`
- **Post Timing:** `utari analytics best-times --platform "instagram"`
- **Content Scheduling:** `brand-operator content schedule <content> --times <times>`

### Manual Posting Support
- **Content Briefs:** `utari content brief <content> --platform "instagram"`
- **Caption Generation:** `utari captions create --content <content>`
- **Visual Recommendations:** `utari visuals recommend <content>`
- **Post Templates:** `brand-operator templates get "organic-post"`

## Integration with Existing Workflow

### Morning Routine (30 min)
1. **Ideation:** `utari ideas brainstorm --topic "Bryson's business"`
2. **Content Review:** `brand-operator content review --new`
3. **Call Analysis:** `fathom-tele-tv process --new-recordings`
4. **Script Generation:** `utari ads create --insights <new-insights>`

### Campaign Optimization
1. **Performance Review:** `brand-operator analytics review --campaign <campaignId>`
2. **Ad Testing:** `utari ads test <ads> --metrics "engagement,conversions"`
3. **Budget Adjustment:** `brand-operator campaigns adjust <campaignId> --metric "ROAS"`
4. **Scaling Decisions:** `brand-operator campaigns scale <winner> --factor 1.5`

## Success Metrics

### Ad Performance
- **ROAS Target:** 15x+ (current baseline)
- **CTR Target:** 2%+ (industry standard)
- **Conversion Rate:** 3%+ (high-quality traffic)
- **Cost Per Acquisition:** Under $50 (profitable)

### Organic Growth
- **Engagement Rate:** 5%+ (algorithm-friendly)
- **Follower Growth:** 10% monthly increase
- **Content Velocity:** 5+ posts per week
- **Lead Generation:** 20+ leads per month from organic

## Tool Requirements

### Core Tools
- **Utari:** Ad scripting and AI content creation
- **Brand Operator:** Campaign management and analytics
- **gog:** Google Drive content discovery
- **Fathom/Tele.tv:** Call and video recording analysis

### Optional Enhancements
- **Canva API:** Visual content creation
- **Hootsuite API:** Social media scheduling (for non-organic posts)
- **Google Analytics:** Deeper performance tracking
- **Facebook Ads API:** Direct ad management

## Notes

- Respects manual posting preference for organic content
- Focuses ad automation on performance optimization
- Integrates with existing 30-minute morning routine
- Scales systematically while maintaining quality
- Provides clear metrics for decision-making