-- 1. Data Profiling

-- Get the total number of rows in the table dengan target 1000
SELECT COUNT(*) AS total_rows
FROM ev_battery_charging_data;

-- Melakukan pengecekan struktur kolom
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'ev_battery_charging_data'
ORDER BY ordinal_position;

-- Melakukan pengecekan data kosong atau null pada setiap kolom
SELECT
    key AS column_name,
    COUNT(*) FILTER (
        WHERE key IS NULL -- mengecek null pada setiap kolom
        OR trim(key) = '' -- mengecek string kosong
        OR key = '[]' -- mengecek array kosong pada setiap kolom
    ) AS total_kosong -- print total kosong
FROM ev_battery_charging_data t,
LATERAL jsonb_each_text(to_jsonb(t)) -- fungsi jsonb_each_text digunakan untuk mengambil setiap kolom dan nilainya dari setiap baris data dalam bentuk pasangan key-value 
GROUP BY key -- mengelompokkan hasil berdasarkan nama kolom (key) sehingga setiap kolom akan dihitung jumlah data kosongnya secara terpisah
ORDER BY total_kosong DESC; -- mengurutkan hasil berdasarkan total_kosong secara menurun (DESC) sehingga kolom dengan jumlah data kosong terbanyak akan ditampilkan terlebih dahulu

-- Mengecek duplicate records
SELECT
    key AS column_name,
    COUNT(*) AS total_duplicate
FROM ev_battery_charging_data t,
LATERAL jsonb_each_text(to_jsonb(t))
GROUP BY key
HAVING COUNT(*) > 1 -
ORDER BY total_duplicate DESC; 

/* Perbaikan program sebelumnya karena key hanya menyimpan nama kolom dan belum bisa mengecek 
data duplikat berdasarkan nilai seluruh baris */

/* with stats digunakan sebagai Common Table Expression (CTE) untuk membuat tabel sementara yang berisi hasil perhitungan jumlah total baris dan jumlah baris unik dari tabel ev_battery_charging_data.
*/
WITH stats AS ( 
    SELECT 
        COUNT(*) AS total_rows,
        (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM ev_battery_charging_data) sub) AS unique_rows
    FROM ev_battery_charging_data
)
SELECT 
    total_rows,
    unique_rows,
    (total_rows - unique_rows) AS duplicate_rows,
    CASE -- kondisi if else pada sql untuk mnegecek kondisi yang ditentukan
        WHEN total_rows = unique_rows THEN 'Tidak ditemukan exact duplicate records'
        ELSE 'Ada exact duplicate records'
    END AS status
FROM stats;

-- Mencari gambaran umum variabel numerik (descriptive statitiscs)
SELECT 
    key AS column_name,
    COUNT(*) AS total_records,
    ROUND(AVG(value::numeric), 2) AS average_value,
    ROUND(MIN(value::numeric), 2) AS minimum_value,
    ROUND(MAX(value::numeric), 2) AS maximum_value,
    ROUND(STDDEV(value::numeric), 2) AS std_value
FROM ev_battery_charging_data t,
LATERAL jsonb_each_text(to_jsonb(t))
WHERE value ~ '^-?[0-9]+(\.[0-9]+)?$' -- Memastikan hanya kolom angka yang dihitung
GROUP BY key
ORDER BY key;

-- 2. Segmen analisis
--  Analisi berdasarkan Chrging Mode
SELECT
    "Charging Mode",
    COUNT(*) AS total_records,
    ROUND(AVG("Charging Duration (min)")::numeric, 2) AS avg_duration,
    ROUND(AVG("Efficiency (%)")::numeric, 2) AS avg_efficiency,
    ROUND(AVG("Degradation Rate (%)")::numeric, 2) AS avg_degradation
FROM ev_battery_charging_data
GROUP BY "Charging Mode"
ORDER BY avg_duration DESC;

-- Analisis berdasarkan Battery Type
SELECT
    "Battery Type",
    COUNT(*) AS total_records,
    ROUND(AVG("Charging Duration (min)")::numeric, 2) AS avg_duration,
    ROUND(AVG("Efficiency (%)")::numeric, 2) AS avg_efficiency,
    ROUND(AVG("Degradation Rate (%)")::numeric, 2) AS avg_degradation
FROM ev_battery_charging_data
GROUP BY "Battery Type"
ORDER BY avg_duration;

-- Analisis berdasarkan eV Model
SELECT
    "EV Model",
    COUNT(*) AS total_records,
    ROUND(AVG("Charging Duration (min)")::numeric, 2) AS avg_duration,
    ROUND(AVG("Efficiency (%)")::numeric, 2) AS avg_efficiency,
    ROUND(AVG("Degradation Rate (%)")::numeric, 2) AS avg_degradation
FROM ev_battery_charging_data
GROUP BY "EV Model"
ORDER BY avg_duration;

-- Analisis berdasrkan durasi pengisian baterai
WITH categorized_data AS (
    SELECT 
        *,
        CASE
            WHEN "Charging Duration (min)" <= 40 THEN 'Short'
            WHEN "Charging Duration (min)" <= 80 THEN 'Medium'
            ELSE 'Long'
        END AS duration_group
    FROM ev_battery_charging_data
)
SELECT 
    duration_group,
    COUNT(*) AS total_records,
    ROUND(AVG("Efficiency (%)")::numeric, 2) AS avg_efficiency,
    ROUND(AVG("Degradation Rate (%)")::numeric, 2) AS avg_degradation
FROM categorized_data
GROUP BY duration_group
ORDER BY
    CASE duration_group
        WHEN 'Short' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Long' THEN 3
    END;

-- Analisis Operating system
WITH categorized_data AS (
    SELECT 
        *,
        CASE
            WHEN "Charging Duration (min)" <= 30 THEN 'Low SOC'
            WHEN "Charging Duration (min)" <= 70 THEN 'Medium SOC'
            ELSE 'High SOC'
        END AS soc_group
    FROM ev_battery_charging_data
)
SELECT 
    soc_group,
    COUNT(*) AS total_records,
    ROUND(AVG("Efficiency (%)")::numeric, 2) AS avg_efficiency,
    ROUND(AVG("Degradation Rate (%)")::numeric, 2) AS avg_degradation
FROM categorized_data
GROUP BY soc_group
ORDER BY
    CASE soc_group
        WHEN 'Low SOC' THEN 1
        WHEN 'Medium SOC' THEN 2
        WHEN 'High SOC' THEN 3
    END;