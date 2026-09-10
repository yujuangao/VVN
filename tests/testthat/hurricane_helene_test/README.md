# Hurricane Helene Impact on Virginia Vegetation

VVN project generated with `vvnthemes`.

## Workflow

**Step 1 — Build figures**

Open `scripts/analysis.R`, fill in your chart code, then source it:

```r
source("scripts/analysis.R")
# Static figures saved to figures/01_name.png, 02_name.png, ...
# Interactive HTML maps saved to assets/name.html
```

**Step 2 — Write the narrative**

Open `index.qmd`. Replace every `[placeholder]` with your content.
- **Static figures:** update `knitr::include_graphics()` filenames
- **Interactive maps:** uncomment the `.map-card` iframe block and set the `src` path

**Step 3 — Render**

```r
quarto::quarto_render("index.qmd")
```

Output: `index.html` (self-contained, ready to publish)

## Structure

```
hurricane_helene_test/
├── index.qmd            ← Narrative — fill in text, insert figure names
├── _quarto.yml
├── styles.scss          ← VVN brand SCSS (do not edit)
├── assets/              ← Interactive HTML maps/widgets (iframe in index.qmd)
├── data/raw/
├── data/processed/
├── scripts/
│   └── analysis.R       ← Build figures + maps here, then source
└── figures/             ← Static PNG charts
```

