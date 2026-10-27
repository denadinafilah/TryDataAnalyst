# Data dictionary

| Column | Meaning | Type | Unit / values | Analytical role | Notes |
|---|---|---|---|---|---|
| `SOC (%)` | State of charge | Numeric | Percent | Operating state | Interpret as a dataset field, not a causal variable by itself. |
| `Voltage (V)` | Battery voltage | Numeric | Volt | Electrical operating measure | Continuous. |
| `Current (A)` | Charging current | Numeric | Ampere | Electrical operating measure | Continuous. |
| `Battery Temp (°C)` | Battery temperature | Numeric | °C | Operating/condition measure | Continuous. |
| `Ambient Temp (°C)` | Ambient temperature | Numeric | °C | Environmental measure | Continuous. |
| `Charging Duration (min)` | Time required for charging | Numeric | Minutes | Performance metric | Also used to derive the optimal-duration class. |
| `Charging Mode` | Charging mode | Categorical | Fast / Normal / Slow | Segment | Compare group summaries. |
| `Degradation Rate (%)` | Dataset's degradation metric | Numeric | Percent | Battery-condition metric | Described by the dataset as derived from other fields. |
| `Charging Cycles` | Charging-cycle count | Numeric/integer | Count | Battery history | Little linear correlation with degradation in this dataset. |
| `Efficiency (%)` | Dataset's efficiency metric | Numeric | Percent | Performance metric | Documentation describes it as derived from degradation rate. |
| `Battery Type` | Battery chemistry category | Categorical | Li-ion / LiFePO4 | Segment | The observed group means are very similar in this dataset. |
| `EV Model` | EV model label | Categorical | Model A / Model B / Model C | Segment | Labels may be anonymized/generic in the source data. |
| `Optimal Charging Duration Class` | Duration class label | Ordinal/categorical | 0 / 1 / 2 | Supporting label | Derived from charging duration; avoid treating as an independent feature. |
