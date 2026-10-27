# EV Battery Charging Analytics

An end-to-end data analytics portfolio project exploring EV battery charging performance and battery-condition metrics using PostgreSQL, Python, Excel, and Power BI.

![Power BI dashboard preview](dashboard/dashboard_preview.pdf)

## Project objective

Explore how charging duration, state of charge (SOC), charging mode, battery type, and EV model relate to charging efficiency and degradation rate in the selected dataset.

> **Scope note:** this is an exploratory analysis of the supplied dataset, not proof of causal battery behavior or a universal comparison of battery chemistries or EV models.

## Questions explored

1. How do average charging duration, efficiency, and degradation rate vary across charging modes?
2. How do efficiency and degradation metrics compare between battery types?
3. How do charging metrics vary across EV models?
4. Which numerical variables have the strongest linear association with degradation rate?
5. What data-quality checks and derived-variable dependencies matter when interpreting the results?

## Tools and workflow

- **PostgreSQL / DBeaver:** row counts, data-quality checks, category summaries, aggregations, and correlation calculations.
- **Python (Pandas, NumPy, Matplotlib):** exploratory data analysis, distributions, scatter plots, correlation matrix/heatmap, and segment comparisons.
- **Excel:** cross-validation of row counts, missing values, duplicates, numeric ranges, and PivotTable summaries.
- **Power BI:** interactive summary dashboard with KPI cards, EV-model comparisons, and slicers for charging mode, battery type, and EV model.

Workflow: `Raw data → validation → SQL analysis → Python EDA → Excel cross-check → Power BI dashboard → findings`.

## Dataset

- **Source:** [EV_battery_charging_data on Kaggle](https://www.kaggle.com/datasets/ziya07/ev-battery-charging-data)
- **Size:** 1,000 rows × 13 columns.
- **Main fields:** SOC, voltage, current, battery and ambient temperature, charging duration, charging mode, degradation rate, efficiency, charging cycles, battery type, EV model, and optimal charging duration class.

The raw CSV is intentionally not included in this repository by default. Download it from the source above and place it at `data/raw/EV_battery_charging_data.csv`. Check the dataset's license/terms before redistributing the data.

## Key findings

### Charging mode

| Charging mode | Mean duration (min) | Mean efficiency (%) |
|---|---:|---:|
| Fast | 69.40 | 98.01 |
| Normal | 68.94 | 98.00 |
| Slow | 71.16 | 97.98 |

Average efficiency was nearly identical across charging modes. The average charging-duration difference was also modest in this dataset.

### Battery type

| Battery type | Mean efficiency (%) | Mean degradation rate (%) |
|---|---:|---:|
| Li-ion | 98.00 | 9.98 |
| LiFePO4 | 97.99 | 10.05 |

The two battery-type groups had very similar average efficiency and degradation metrics in this dataset.

### EV model

| EV model | Mean duration (min) | Mean efficiency (%) | Mean degradation rate (%) |
|---|---:|---:|---:|
| Model A | 68.60 | 98.01 | 9.95 |
| Model B | 72.81 | 97.95 | 10.27 |
| Model C | 68.25 | 98.03 | 9.84 |

Model B had a higher mean charging duration and degradation rate, and slightly lower mean efficiency than Models A and C. The distributions still overlapped substantially, so these descriptive differences should not be overstated.

### Correlation and interpretation

| Variable vs. degradation rate | Pearson correlation |
|---|---:|
| Efficiency | -1.000 |
| Charging duration | +0.869 |
| SOC | +0.431 |
| Battery temperature | +0.128 |
| Voltage | +0.040 |
| Ambient temperature | -0.038 |
| Charging cycles | -0.017 |
| Current | -0.013 |

Charging duration showed a strong positive linear association with degradation rate; SOC showed a more moderate positive association; battery temperature showed a weak linear association. Correlation does not establish causality.

**Important dependency caveat:** the dataset documentation describes efficiency as derived from degradation rate, so the perfect negative correlation (`r = -1.000`) should be interpreted as a likely constructed/derived relationship, not an independent discovery that efficiency causes degradation or vice versa. The optimal charging duration class is derived from charging duration and should not be treated as an independent explanatory variable.

## Data quality checks

The analysis reported 1,000 observations, no missing values, and no duplicate rows. Numeric ranges were cross-checked in Python/SQL and Excel after correcting the decimal-locale handling during Excel import.

## Repository structure

```text
.
├── README.md
├── requirements.txt
├── .gitignore
├── data/
│   └── raw/                  # Place the downloaded CSV here (not tracked by default)
├── sql/
│   └── analysis_queries.sql
├── python/
│   └── 01_eda_ev_battery.py
├── excel/
│   └── README.md             # Notes for the validation workbook
├── powerbi/
│   └── README.md             # Notes for the .pbix dashboard file
├── docs/
│   ├── data_dictionary.md
│   └── insights.md
├── dashboard/
│   └── dashboard_preview.png
└── reports/                  # Optional exported report images/PDF
```

## Run the Python analysis

1. Download the CSV from Kaggle and place it at `data/raw/EV_battery_charging_data.csv`.
2. Create and activate a virtual environment.
3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

4. Run:

   ```bash
   python python/01_eda_ev_battery.py
   ```

Figures are saved under `reports/figures/`.

## Power BI and Excel files

Place the finished workbook and Power BI file in `excel/` and `powerbi/`, respectively, if you intend to publish them. Review file sizes and verify that no private connection strings, credentials, or sensitive information are embedded. GitHub warns on regular Git files larger than 50 MiB and blocks files larger than 100 MiB; browser uploads are limited to 25 MiB. See the [GitHub guidance on large files](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github).

## Limitations

- Findings describe this dataset and may not generalize to real-world EV batteries.
- Group mean differences are descriptive; no statistical significance test or causal analysis is claimed.
- Correlation measures linear association and may not capture nonlinear patterns or interactions.
- Derived/related fields can produce strong correlations by construction.

## Author

Data analytics portfolio project by **Dena Siti Dinafilah**.
