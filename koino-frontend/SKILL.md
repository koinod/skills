---
name: koino-frontend
description: Build world-class frontend interfaces for KOINO Capital and client ventures. Combines Anthropic's frontend-design principles, Impeccable refinements, modern SaaS landing page patterns, and KOINO operational alpha. Produces sites that rival top creative agencies and YC startup landing pages. Activates when building any web UI, landing page, storefront, dashboard, or component.
---

# KOINO Frontend — Production-Grade Web Interfaces

Build interfaces that look like a top-tier creative agency and a YC startup had a child raised by operators who actually ship. Not generic. Not AI slop. Not template-town. Every page should make someone stop scrolling.

## When to Activate

- Building landing pages, storefronts, product pages
- Creating dashboards or admin interfaces
- Designing any web component, page, or application
- Styling, beautifying, or redesigning existing UI
- Creating email templates or marketing assets

## Phase 1: Design Thinking (Before Any Code)

### Context Gathering
1. **Purpose**: What does this interface need to accomplish? What's the conversion goal?
2. **Audience**: Who sees this? Solo operators, agency owners, enterprise buyers, developers?
3. **Tone**: Choose ONE bold direction and commit fully:
   - Terminal/Operator (dark, monospace, hacker energy — KOINO default)
   - Luxury/Refined (serifs, gold accents, editorial spacing)
   - Brutalist/Raw (system fonts, harsh grids, anti-design)
   - Organic/Warm (rounded, natural colors, friendly)
   - Retro-Futuristic (neon, chrome, sci-fi)
   - Editorial/Magazine (bold typography, asymmetric layouts, art direction)
4. **Differentiation**: What's the ONE thing someone remembers? The terminal animation? The pricing table? The scroll effect?
5. **Constraints**: Framework, performance budget, accessibility needs, mobile-first?

### The KOINO Default Aesthetic
When building for KOINO Capital or when no specific direction is given:

```
Theme:     Dark operator terminal
Background: #050505 (near-black, NOT pure black)
Surface:    #0d0d0d, #151515 (layered depth)
Borders:    #1a1a1a (subtle, not heavy)
Text:       #e8e8e8 (off-white, easier on eyes than #fff)
Secondary:  #888888 (muted, for descriptions)
Accent:     #00d4aa (teal-green, confidence + growth)
Secondary:  #7c3aed (purple, for premium/featured elements)
Gold:       #f59e0b (for "best value" / urgency)
Fonts:      JetBrains Mono (headings, tags, code) + Inter (body)
Grain:      SVG noise overlay at 3% opacity
Glow:       Radial gradients behind hero elements
Motion:     Scroll-triggered fade-in, pulse animations on live indicators
```

## Phase 2: Typography

### Rules
- **NEVER** use system defaults (Arial, Helvetica, sans-serif) as primary fonts
- **NEVER** use Inter as a heading font (it's acceptable for body only when paired with a distinctive display font)
- **DO** pair a display/mono font with a clean body font
- **DO** use CSS variables for consistent type scales
- **DO** use `clamp()` for fluid responsive sizing

### Recommended Pairings (by tone)
| Tone | Display | Body |
|------|---------|------|
| Operator/Terminal | JetBrains Mono | Inter |
| Luxury | Playfair Display | Source Sans 3 |
| Brutalist | Space Mono | IBM Plex Sans |
| Editorial | Fraunces | Instrument Sans |
| Startup/Clean | Cabinet Grotesk | DM Sans |
| Retro-Future | Orbitron | Exo 2 |

### Type Scale (fixed for apps, fluid for marketing)
```css
/* Marketing/Landing pages — fluid */
--text-xs: clamp(0.75rem, 0.7rem + 0.25vw, 0.85rem);
--text-sm: clamp(0.85rem, 0.8rem + 0.25vw, 0.95rem);
--text-base: clamp(0.95rem, 0.9rem + 0.25vw, 1.1rem);
--text-lg: clamp(1.1rem, 1rem + 0.5vw, 1.3rem);
--text-xl: clamp(1.5rem, 1.2rem + 1vw, 2rem);
--text-2xl: clamp(2rem, 1.5rem + 2vw, 3rem);
--text-hero: clamp(2.8rem, 2rem + 3vw, 4.5rem);

/* App UIs — fixed scale */
--text-xs: 0.75rem;  --text-sm: 0.875rem;  --text-base: 1rem;
--text-lg: 1.125rem; --text-xl: 1.5rem;    --text-2xl: 2rem;
```

## Phase 3: Color & Theme

### Rules
- Use CSS custom properties for ALL colors — no hardcoded hex in components
- Dominant + accent outperforms evenly distributed palettes
- Dark themes: use layered surfaces (#050505 → #0d0d0d → #151515) for depth, NOT flat black
- Light themes: off-white (#fafafa) base, NOT pure white (#fff)
- Every interactive element needs a visible hover state
- Use `rgba()` or `color-mix()` for transparent variants of your accent

### Anti-Patterns (Never Do These)
- Purple gradient on white background (the #1 AI slop indicator)
- Rainbow gradients with no purpose
- Low-contrast text on busy backgrounds
- More than 3 accent colors competing for attention
- Neon colors on light backgrounds

### Glow & Depth Effects
```css
/* Accent glow behind hero elements */
.hero::before {
    content: '';
    position: absolute;
    width: 600px; height: 600px;
    background: radial-gradient(circle, rgba(0,212,170,0.15) 0%, transparent 70%);
    pointer-events: none;
}

/* Card hover glow */
.card:hover {
    border-color: var(--accent);
    box-shadow: 0 8px 30px rgba(0,212,170,0.1);
}

/* Film grain overlay (adds texture, prevents flat feel) */
body::before {
    content: '';
    position: fixed; inset: 0;
    background-image: url("data:image/svg+xml,..."); /* SVG feTurbulence noise */
    opacity: 0.03;
    pointer-events: none;
    z-index: 9999;
}
```

## Phase 4: Layout & Composition

### Rules
- Mobile-first: design at 375px, then expand
- Max content width: 1200px for marketing, 1400px for dashboards
- Use CSS Grid for page layout, Flexbox for component layout
- Generous padding: 24px minimum on mobile, 32-48px on desktop
- Section spacing: 80-120px between major sections
- Sticky nav with backdrop-filter blur (the 2026 standard)

### Landing Page Structure (Conversion-Optimized)
```
1. Nav (sticky, blurred, minimal links, persistent CTA)
2. Hero (badge + h1 + subtitle + 2 CTAs + visual/demo)
3. Social proof bar (4 metrics in grid)
4. Product section (cards with clear pricing + CTAs)
5. How it works (3 steps, numbered)
6. Testimonials or case study (real, specific)
7. CTA section (repeat primary action)
8. Footer (brand, links, legal)
```

### Grid Patterns
```css
/* Product cards — auto-fill responsive grid */
.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px; }

/* Stats bar — equal columns with 1px gap borders */
.stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1px; background: var(--border); border-radius: 12px; overflow: hidden; }
.stat { background: var(--surface); padding: 32px; text-align: center; }

/* Pricing tiers — fixed 3-column */
.tiers { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
```

## Phase 5: Motion & Animation

### Rules
- Prefer CSS animations over JS (performance, accessibility)
- Scroll-triggered fade-in using IntersectionObserver (not scroll event listeners)
- Page load: stagger reveal with `animation-delay` (0.1s increments)
- Hover states on ALL interactive elements
- Keep animations under 0.6s (0.2-0.4s for micro-interactions)
- Use `prefers-reduced-motion` media query to disable for accessibility

### Essential Animations
```css
/* Scroll reveal */
.reveal { opacity: 0; transform: translateY(20px); transition: opacity 0.6s, transform 0.6s; }
.reveal.visible { opacity: 1; transform: translateY(0); }

/* Pulse indicator (live status) */
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }
.live-dot { animation: pulse 2s infinite; }

/* Card hover lift */
.card { transition: transform 0.2s, border-color 0.2s, box-shadow 0.2s; }
.card:hover { transform: translateY(-2px); }

/* Button press */
.btn:active { transform: scale(0.98); }
```

### IntersectionObserver Pattern (Standard)
```javascript
const observer = new IntersectionObserver(entries => {
    entries.forEach(e => {
        if (e.isIntersecting) {
            e.target.classList.add('visible');
        }
    });
}, { threshold: 0.1 });
document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
```

## Phase 6: Components Library

### Nav (Sticky, Blurred)
```css
nav {
    position: fixed; top: 0; left: 0; right: 0; z-index: 100;
    background: rgba(5,5,5,0.8);
    backdrop-filter: blur(20px);
    border-bottom: 1px solid var(--border);
}
```

### Hero Badge (Live Indicator)
```html
<div class="badge"><span class="dot"></span> Status message here</div>
```
Small pill with pulsing dot. Signals activity/liveness. Use above h1.

### Pricing Card (Featured Variant)
- Default: surface bg + border
- Featured: accent border + gradient bg (subtle) + "BEST VALUE" tag
- Always include: tag, title, description, feature list, price, CTA button

### Terminal/Code Block
Fake terminal with macOS dots (red/yellow/green), title bar, and monospace content. Communicates "we're technical, we build things." Use for demos, live status, code examples.

### Section Tag
```html
<div class="section-tag">// section name</div>
```
Monospace, uppercase, accent color, small. Creates visual rhythm between sections.

## Phase 7: Performance & Accessibility

### Performance
- No external JS frameworks for static landing pages (vanilla JS only)
- Fonts: `font-display: swap` + preconnect to Google Fonts
- Images: lazy load with `loading="lazy"`, use WebP/AVIF
- CSS: inline critical styles, defer non-critical
- Target: <2s LCP, <100ms FID, <0.1 CLS

### Accessibility
- Semantic HTML (nav, main, section, article, footer)
- Color contrast: minimum 4.5:1 for text, 3:1 for large text
- All interactive elements focusable and keyboard-navigable
- `prefers-reduced-motion` support
- Alt text on all images
- ARIA labels on icon-only buttons

### Mobile Responsive Breakpoints
```css
/* Tablet */
@media (max-width: 768px) {
    .grid { grid-template-columns: 1fr; }
    nav .links { display: none; } /* hamburger or simplified nav */
}
/* Small mobile */
@media (max-width: 480px) {
    .hero h1 { font-size: 2rem; }
    .section { padding: 40px 0; }
}
```

## Phase 8: KOINO Alpha (Our Edge)

### What We Know That Others Don't

1. **Terminal aesthetic converts for technical buyers.** The fleet status terminal on koino.capital communicates "we actually build things" more than any hero image. Show the system running.

2. **Stats > claims.** "1,847 clips processed" beats "We process lots of content." Real numbers, monospace font, grid layout. Let the numbers do the selling.

3. **Monospace section tags create visual rhythm.** `// individual operators` before a section feels like reading code. It signals operator mindset.

4. **Dark mode is the default for our ICP.** Developers, operators, and agency owners live in dark mode. Light themes feel corporate. We don't feel corporate.

5. **Featured cards need gradient backgrounds, not just borders.** `background: linear-gradient(180deg, rgba(accent, 0.08), var(--surface))` is the difference between "looks different" and "I want that one."

6. **Price anchoring works.** Show the original price crossed out, the new price, and "SAVE X%" in gold. Bundle should always be visually dominant.

7. **Mailto > Calendly for high-ticket.** Enterprise buyers reply to emails. They don't book themselves on Calendly like a dentist appointment.

8. **One CTA per viewport.** Sticky nav CTA + section CTA is fine. Three CTAs competing in the same viewport kills conversion.

9. **The grain overlay is non-negotiable.** 3% opacity SVG noise on dark backgrounds prevents the flat digital look. It adds warmth and texture without performance cost.

10. **Ship speed > pixel perfection.** A live page converting at 2% beats a Figma mockup converting at 0%. Build it, deploy it, iterate from real data.

## Anti-Patterns (The Slop Detector)

If your output has ANY of these, you've failed:

- [ ] Inter or system-ui as the only font
- [ ] Purple-to-blue gradient on white background
- [ ] Generic hero with stock illustration
- [ ] "Get Started for Free" with no context
- [ ] Equal-weight buttons (no visual hierarchy)
- [ ] Pricing table with "Contact Us" on every tier
- [ ] Testimonials with no names, photos, or specifics
- [ ] Mobile nav that's just "hidden desktop nav"
- [ ] Animations that fire on every scroll, not just first appearance
- [ ] No hover states on interactive elements

## Deployment

### Static Sites (Vercel)
```bash
# From project root
vercel deploy --prod
```

### Files needed: index.html, vercel.json, package.json
vercel.json: cleanUrls, security headers, rewrites for clean routes.

### Iteration Workflow
1. Build locally, test at localhost
2. Deploy to Vercel preview (vercel deploy)
3. Review on mobile + desktop
4. Deploy to production (vercel deploy --prod)
5. Check koino.capital, verify all links work
6. Iterate from real user feedback
