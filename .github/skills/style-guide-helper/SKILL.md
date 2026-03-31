---
name: style-guide-helper
description: Checks figure-generating code against exhibit guidelines and, by default, applies presentation-only fixes. Supports two modes: fix mode (default) and audit-only mode when the user asks to only review and flag issues.
metadata:
  authors: Giuseppe Cognata, Paul Metzler, Gillian Richard, Anna Volpp
  created: March 2026
---

# Exhibit Style Enforcer

Check code that generates plots and make sure exhibits follow the style guide.

Default behavior:

1. inspect the plot-generating code
2. compare it to the style guide
3. apply safe presentation-only fixes
4. report what was changed and what still needs judgment

If the user explicitly asks to only review, audit, check, or flag issues, switch to **audit-only mode** and do not modify files.

## General rules

- Change source code, not exported image files.
- Preserve the analysis and data logic.
- Make the smallest reliable diff.
- Prefer project-level helpers when they control many plots.
- If a rule depends on visual judgment, render the plot if possible.
- If uncertain, flag instead of guessing.

## Modes

### Fix mode (default)
Use when the user wants exhibits brought into compliance.

In fix mode:

- inspect code and outputs
- apply safe style fixes
- re-render if feasible
- report changes and unresolved issues

### Audit-only mode
Use only if the user explicitly requests review without edits.

In audit-only mode:

- inspect code and outputs
- list inconsistencies with the style guide
- do not edit files

## Workflow

### 1. Find the real plot-generating code
Search for the scripts or helpers that actually produce the figures the user cares about.

Look for patterns such as:

- R: `ggplot`, `ggsave`, `labs`, `ylab`, `scale_y_continuous`, `scale_color_brewer`, `facet_`, `theme`, `legend.position`
- Python: `plotnine`, `savefig`, `legend`, `set_ylabel`, `scale_color_brewer`

Do not assume the first matching script is the right one.

### 2. Classify the exhibit
Assign the exhibit to one of these contexts:

- paper figure
- appendix figure
- diagnostic plot
- animation
- social media graphic
- faceted plot
- two-series histogram
- unknown

If unclear, default to **paper figure**.

### 3. Evaluate rules by category

## Rule categories

### A. Export rules
Usually safe to autofix.

Check for:

- PNG output
- width 8 inches
- height 4.5 inches
- 300 dpi

Exception:
- if clearly for social media, allow wider formats such as 8 x 4

### B. Text and capitalization
Usually safe to autofix if text is explicit in code.

Check for:

- titles in title case
- axis labels in sentence case

Do not add titles to paper figures just because none appear in code; titles may be added in LyX or LaTeX later.

### C. Scale formatting
Autofix only when units are clear.

Check for:

- percent variables use percent labels
- dollar variables use dollar labels

If units are ambiguous, flag instead of changing.

### D. Axis-label structure
Mostly safe once plot type is known.

Check for:

- non-faceted plots use `subtitle` instead of a vertical y-axis label
- faceted plots keep a vertical y-axis label
- `theme(plot.title.position = "plot")` is set when subtitle is used this way

### E. Colors and distinguishability
Partly safe, partly contextual.

Check for:

- `Blues` for two-color or continuous single-variable movement
- `Set2` for qualitative categories
- added shape or linetype when needed for black-and-white readability

If color meaning is substantive or project-wide, flag before changing.

### F. Legend placement
Often requires visual judgment.

Default:
- bottom-right inside the plotting area

Exceptions:
- move if it blocks data
- put below the plot if no safe internal placement exists
- for animations, keep legend placement stable

Autofix only when the correct location is obvious.

### G. Specialized plot rules
Check when relevant.

- two-series histograms: side-by-side for similarity, solid vs hollow for contrast
- faceted plots: facet-specific labels should be facet-aware
- animations: legend should not shift across frames

These are usually flag-first unless intent is obvious.

### H. Social-media-specific rules
Apply only if the figure is clearly for social media.

Check for:

- extra-wide aspect ratio
- title communicates the main lesson
- figure is self-contained without notes
- direct labeling of line series when feasible

## Decision buckets

Put every finding into one of these buckets.

### Safe autofix
Examples:

- export format and size
- dpi
- obvious capitalization
- `plot.title.position = "plot"`
- moving y-label to subtitle in a non-faceted plot when subtitle is unused
- clear percent/dollar formatting
- obvious palette fixes

### Needs judgment
Examples:

- legend placement
- whether a plot title belongs in code
- whether direct labels are better than a legend
- whether a figure is clearly social-media-oriented

### Flag only
Examples:

- unclear units
- unclear narrative intent
- histogram style depends on author goal
- broad palette changes that may affect project-wide consistency

## Language guidance

## R
Preferred for these style rules.

Check especially:

- `labs(...)`
- `xlab(...)`
- `ylab(...)`
- `scale_y_continuous(...)`
- `scale_color_brewer(...)`
- `scale_fill_brewer(...)`
- `theme(...)`
- `facet_wrap(...)`, `facet_grid(...)`
- `ggsave(...)`

## Python
Prefer `plotnine` if that is already what the project uses.

If the code uses `matplotlib`, do not rewrite the whole plotting system just for style. Apply the closest equivalent fixes with minimal disruption.

## Verification

If possible, render the plot and check:

- export settings
- legend overlap
- label placement
- color distinguishability
- capitalization consistency

If you cannot render the plot, say so clearly and treat the result as a code-only audit.

## Do not change

Do not:

- alter the data or analysis
- rewrite the plotting stack without being asked
- remove substantive annotations
- add titles to paper figures by default
- force style rules when the guide allows exceptions for clarity

## Output format

### In fix mode
Return:

1. files inspected
2. changes made
3. issues still needing judgment
4. whether plots were rendered and visually checked

### In audit-only mode
Return a concise findings table with:

- file
- issue
- category
- confidence
- recommended fix
- safe to autofix? yes/no

## Defaults for ambiguous cases

- If the user says review, audit, check, or flag, use audit-only mode.
- Otherwise use fix mode.
- If context is unknown, treat as paper figure.
- If units are unclear, do not force scale formatting.
- If a legend move is uncertain and you cannot render the result, flag it.
- If a shared helper controls many plots, prefer fixing that helper once.