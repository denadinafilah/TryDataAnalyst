import pandas as pd
import matplotlib.pyplot as plt
from sqlalchemy import create_engine

# Koneksi ke PostgreSQL
engine = create_engine(
    " "
)

# Ambil data
query = """
SELECT *
FROM ev_battery_charging_data;
"""

df = pd.read_sql(query, engine)

print(df.head())
print("\nShape:", df.shape)

print("\n--- DATA INFO ---")
print(df.info())

print("\n--- DESCRIPTIVE STATISTICS ---")
print(df.describe())

print("\n--- MISSING VALUES ---")
print(df.isna().sum())

# DISTRIBUTION: CHARGING DURATION 

plt.figure(figsize=(8, 5))

plt.hist(df["Charging Duration (min)"], bins=20) # bins itu untuk membagi rentang data menjadi beberapa interval

plt.title("Distribution of Charging Duration")
plt.xlabel("Charging Duration (min)")
plt.ylabel("Number of Observations")

plt.tight_layout()
plt.show()

# DISTRIBUTION: EFFICIENCY 

plt.figure(figsize=(8, 5))

plt.hist(df["Efficiency (%)"], bins=20)

plt.title("Distribution of Charging Efficiency")
plt.xlabel("Efficiency (%)")
plt.ylabel("Number of Observations")

plt.tight_layout()
plt.show()


# DISTRIBUTION: DEGRADATION 

plt.figure(figsize=(8, 5))

plt.hist(df["Degradation Rate (%)"], bins=20)

plt.title("Distribution of Battery Degradation Rate")
plt.xlabel("Degradation Rate (%)")
plt.ylabel("Number of Observations")

plt.tight_layout()
plt.show()

# RELATIONSHIP: CHARGING DURATION VS DEGRADATION RATE 

plt.figure(figsize=(8, 5))

plt.scatter(
    df["Charging Duration (min)"],
    df["Degradation Rate (%)"]
)

plt.title("Charging Duration vs Battery Degradation Rate")
plt.xlabel("Charging Duration (min)")
plt.ylabel("Degradation Rate (%)")

plt.tight_layout()
plt.show()

# Hubungan Charging Duration Vs Efficiency 

plt.figure(figsize=(8, 5))

plt.scatter(
    df["Charging Duration (min)"],
    df["Efficiency (%)"]
)

plt.title("Charging Duration vs Charging Efficiency")
plt.xlabel("Charging Duration (min)")
plt.ylabel("Efficiency (%)")

plt.tight_layout()
plt.show()

# CORRELATION ANALYSIS 

numeric_cols = [
    "SOC (%)",
    "Voltage (V)",
    "Current (A)",
    "Battery Temp (°C)",
    "Ambient Temp (°C)",
    "Charging Duration (min)",
    "Degradation Rate (%)",
    "Efficiency (%)",
    "Charging Cycles"
]

correlation_matrix = df[numeric_cols].corr()

print("\n--- CORRELATION MATRIX ---")
print(correlation_matrix.round(2))

# CORRELATION HEATMAP

plt.figure(figsize=(10, 8))

plt.imshow(correlation_matrix, cmap="coolwarm", vmin=-1, vmax=1)

plt.colorbar(label="Correlation")

plt.xticks(
    range(len(correlation_matrix.columns)),
    correlation_matrix.columns,
    rotation=90
)

plt.yticks(
    range(len(correlation_matrix.columns)),
    correlation_matrix.columns
)

plt.title("Correlation Matrix of Numerical Variables")

plt.tight_layout()
plt.show()

print("\n--- CHARGING MODE ---")
print(df["Charging Mode"].value_counts()) #menggitung berdasarkan kategori yang ada di kolom Charging Mode

print("\n--- CHARGING DURATION MODE ---")
duration_mode = df.groupby("Charging Mode")["Charging Duration (min)"].agg(
     ["count", "mean", "median", "min", "max"]
)
print(duration_mode.round(2))

print("\n--- EFFICIENCY MODE ---")
efficiency_mode = df.groupby("Charging Mode")["Efficiency (%)"].agg(
     ["count", "mean", "median", "min", "max"]
)
print(efficiency_mode.round(2))

print("\n--- EFFICIENCY BATTERY TYPE MODE ---")
efficiency_mode = df.groupby("Battery Type")["Efficiency (%)"].agg(
     ["count", "mean", "median", "min", "max"]
)
print(efficiency_mode.round(2))

print("\n--- DEGRADATION BATTERY TYPE MODE ---")
degradation_battery = df.groupby("Battery Type")["Degradation Rate (%)"].agg(
     ["count", "mean", "median", "min", "max"]
)
print(degradation_battery.round(2))

# Grafik boxplot untuk melihat distribusi Degradation Rate berdasarkan Battery Type
df.boxplot(
    column="Degradation Rate (%)",
    by="Battery Type",
    figsize=(8, 5)
)

plt.title("Degradation Rate by Battery Type")
plt.suptitle("")
plt.xlabel("Battery Type")
plt.ylabel("Degradation Rate (%)")

plt.tight_layout()
plt.show()

#pengecekan distribusi data berdasarkan EV Model
print("\n--- EV MODEL ---")

print(df["EV Model"].value_counts())

#Melihat pengaruh EV Model terhadap Charging Duration, efficiency, dan Degradation Rate
print("\n--- CHARGING DURATION BY EV MODEL ---")
charging_duration_ev = df.groupby("EV Model")["Charging Duration (min)"].agg(
     ["count", "mean", "median", "min", "max"]
)
print(charging_duration_ev.round(2))

print("\n--- EFFICIENCY BY EV MODEL ---")
efficiency_ev = df.groupby("EV Model")["Efficiency (%)"].agg(
        ["count", "mean", "median", "min", "max"]
    )   
print(efficiency_ev.round(2))

print("\n--- DEGRADATION RATE BY EV MODEL ---")
degradation_ev = df.groupby("EV Model")["Degradation Rate (%)"].agg(
        ["count", "mean", "median", "min", "max"]
    )
print(degradation_ev.round(2))


#Mencari hubungan antara Charging Duration, Degradation Rate, dan Efficiency berdasarkan EV Model
print("\n --- CORRELATION BY EV MODEL ---")

for model in df["EV Model"].unique():
    model_data = df[df["EV Model"] == model]

    corr = model_data[
        [
            "Charging Duration (min)",
            "Degradation Rate (%)",
            "Efficiency (%)"
        ]
    ].corr()

    print(f"\n--- {model} ---")
    print(f"Duration vs Degradation: {corr.loc['Charging Duration (min)', 'Degradation Rate (%)']:.6f}")
    print(f"Duration vs Efficiency: {corr.loc['Charging Duration (min)', 'Efficiency (%)']:.6f}")

# Visualisasi hubungan Charging Duration, Degradation Rate, dan Efficiency berdasarkan EV Model
df.boxplot(
    column="Charging Duration (min)",
    by="EV Model",
    figsize=(8, 5)
)

plt.title("Charging Duration by EV Model")
plt.suptitle("")
plt.xlabel("EV Model")
plt.ylabel("Charging Duration (min)")

plt.tight_layout()
plt.show()

df.boxplot(
    column="Degradation Rate (%)",
    by="EV Model",
    figsize=(8, 5)
)

plt.title("Degradation Rate by EV Model")
plt.suptitle("")
plt.xlabel("EV Model")
plt.ylabel("Degradation Rate (%)")

plt.tight_layout()
plt.show()

df.boxplot(
    column="Efficiency (%)",
    by="EV Model",
    figsize=(8, 5)
)

plt.title("Efficiency by EV Model")
plt.suptitle("")
plt.xlabel("EV Model")
plt.ylabel("Efficiency (%)")

plt.tight_layout()
plt.show()

# Melihat hubungan SOC terhdap Degradasi Rate dan Efficiency
plt.figure(figsize=(8, 5))

plt.scatter(
    df["SOC (%)"],
    df["Degradation Rate (%)"],
    alpha=0.6
)

plt.title("SOC vs Degradation Rate")
plt.xlabel("SOC (%)")
plt.ylabel("Degradation Rate (%)")

plt.tight_layout()
plt.show()

plt.figure(figsize=(8, 5))

plt.scatter(
    df["SOC (%)"],
    df["Efficiency (%)"],
    alpha=0.6
)

plt.title("SOC vs Efficiency")
plt.xlabel("SOC (%)")
plt.ylabel("Efficiency (%)")

plt.tight_layout()
plt.show()

plt.figure(figsize=(8, 5))

plt.scatter(
    df["Battery Temp (°C)"],
    df["Degradation Rate (%)"],
    alpha=0.6
)

plt.title("Battery Temperature vs Degradation Rate")
plt.xlabel("Battery Temperature (°C)")
plt.ylabel("Degradation Rate (%)")

plt.tight_layout()
plt.show()

# Mmebuat korelasi data secara keseluruhan terkait degradasi baterai
print("\n --- CORRELATION WITH DEGRADATION RATE ---")

target = "Degradation Rate (%)"

corr_with_target = (
    df[numeric_cols]
    .corr()[target]
    .drop(target)
    .sort_values(key=abs, ascending=False)
)

print(corr_with_target.round(3))