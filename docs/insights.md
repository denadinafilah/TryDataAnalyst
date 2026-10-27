# Findings and interpretation

## Descriptive segment comparisons

- **Charging mode:** mean duration ranged from 68.94 min (Normal) to 71.16 min (Slow); mean efficiency ranged only from 97.98% to 98.01%.
- **Battery type:** mean efficiency was 98.00% for Li-ion and 97.99% for LiFePO4; mean degradation was 9.98% and 10.05%, respectively.
- **EV model:** Model B had the longest mean duration (72.81 min), lowest mean efficiency (97.95%), and highest mean degradation rate (10.27%). Models A and C had similar average duration and degradation. Distributions overlapped substantially.

## Pearson correlations with degradation rate

- Charging duration: **+0.869** (strong positive linear association).
- SOC: **+0.431** (moderate positive linear association).
- Battery temperature: **+0.128** (weak positive linear association).
- Charging cycles: **-0.017** (almost no linear association in this dataset).
- Efficiency: **-1.000**, likely reflecting documented feature dependency because efficiency is derived from degradation.

## Across-model correlation check

Correlation between charging duration and degradation was approximately 0.866–0.871 across Models A/B/C. Duration and efficiency correlations were approximately -0.866 to -0.871. This suggests a similar linear pattern across model segments in this dataset, but rounded descriptive correlations alone do not constitute a formal test of interaction or moderation.

## Limitations

These are descriptive and exploratory results. Small mean differences are not labelled statistically significant because no significance tests are reported. Correlations do not establish causation. Documentation indicates derived relationships among some fields, so perfect/strong correlations must be interpreted with feature lineage in mind.
