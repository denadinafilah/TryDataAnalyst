
/* 
SELECT fungsinya untuk memilih kolom yang akan di tampilkan
FROM fungsinya menentukan sumber data yang akan diambil (netflix_titles)
LIMIT fungsinya untuk membatasi jumlah data yang akan di tampilkan (10 data)
; untuk menandai akhir dari perintah SQL
*/

SELECT * FROM netflix_titles LIMIT 10;

/*
Membuat program untuk analisis data netflix_titles dengan menggunakan perintah SQL
untuk menghitung total data yang tersedia menggunakan fungsi COUNT(*) 
dan mengelompokkan data berdasarkan kolom type menggunakan GROUP BY
*/
-- program melihat total data yang tersedia berdasarkan type (MOVIE/SHOW) menggunakan fungsi COUNT(*) dan mengelompokkan data berdasarkan kolom type menggunakan GROUP BY
SELECT 
    type, 
    COUNT(*) AS total
FROM netflix_titles
GROUP BY type;


/* membuat program untuk menganalisis total data yang tersedia berdasarkan tahun rilis menggunakan fungsi COUNT(*)
dan mengelompokkan data berdasarkan kolom release_year menggunakan GROUP BY. menggunakan fungsi ORDER BY untuk mengurutkan data berdasarkan total_konten secara menurun (DESC) 
dan membatasi jumlah data yang ditampilkan menggunakan LIMIT 10  */
SELECT 
    release_year, 
    COUNT(*) AS total_konten
FROM netflix_titles
GROUP BY release_year
ORDER BY total_konten DESC
LIMIT 10;


/* melakukan celaning atau pengecekan nilai NULL pada kolom director dan menampilkan data yang memiliki nilai NULL pada kolom tersebut
menggunakan rumus Total Seluruh Baris – Baris yang Berisi Data = Jumlah Baris yang Kosong (NULL)
dengan menggunakan fungsi COUNT(*) - COUNT(data kolom) secara sederhana */
SELECT
    COUNT(*) - COUNT(id) AS null_id,
    COUNT(*) - count(title) AS null_title,
    COUNT(*) - COUNT(type) AS null_type,
    COUNT(*) - COUNT(description) AS null_description,
    COUNT(*) - COUNT(release_year) AS null_release_year,
    COUNT(*) - COUNT(age_certification) AS null_age_certification,
    COUNT(*) - COUNT(runtime) AS null_runtime,
    COUNT(*) - COUNT(genres) AS null_genres,
    COUNT(*) - COUNT(production_countries) AS null_production_countries,
    COUNT(*) - COUNT(seasons) AS null_seasons,
    COUNT(*) - COUNT(imdb_id) AS null_imdb_id,
    COUNT(*) - COUNT(imdb_score) AS null_imdb_score,
    COUNT(*) - COUNT(imdb_votes) AS null_imdb_votes,
    COUNT(*) - COUNT(tmdb_popularity) AS null_tmdb_pop,
    COUNT(*) - COUNT(tmdb_score) AS null_tmdb_score
FROM netflix_titles;
-- program ini hanya bisa mendeteksi data yang kosong (NULL)

--program pengecekan nilai kosong (NULL) dan string kosong ('') pada kolom age_certification
SELECT DISTINCT age_certification 
FROM netflix_titles;

SELECT COUNT(*) AS total_kosong
FROM netflix_titles
WHERE age_certification IS NULL OR age_certification = '';
/* berdasarkan program ini diketahui bahwa pada postgresql null dan string kosong ('')
adalah dua hal berbeda, sehingga untuk mendeteksi data kosong pada kolom age_certification 
harus menggunakan perintah WHERE age_certification IS NULL OR age_certification = '' */ 


/* sekarang aku mau buat program yang bisa analisis null dan string kosong sekaligus meringkas 
penulisan sytaxnya agar tidak manual satu per satu karena tidak efisien untuk menghitung jumlah 
data kosong pada beberapa kolom sekaligus */

SELECT 
    key AS nama_kolom, --mengambil setiap type data yang ada pada kolom netflix_titles (key) dan menjadikannya sebagai nama_kolom
    COUNT(*) FILTER (
        WHERE value IS NULL  -- mengecek null pada setiap kolom
           OR TRIM(value) = '' -- mengecek string kosong pada setiap kolom
           OR value = '[]' -- mengecek array kosong pada setiap kolom
    ) AS total_kosong -- Menulis total_kosong untuk menampilkan jumlah data kosong pada setiap kolom
FROM netflix_titles t, -- diimport data dari tabel netflix_titles dengan alias t
LATERAL jsonb_each_text(to_jsonb(t)) -- fungsi jsonb_each_text digunakan untuk mengambil setiap kolom dan nilainya dari setiap baris data dalam bentuk pasangan key-value 
GROUP BY key -- mengelompokkan hasil berdasarkan nama kolom (key) sehingga setiap kolom akan dihitung jumlah data kosongnya secara terpisah
ORDER BY total_kosong DESC; -- mengurutkan hasil berdasarkan total_kosong secara menurun (DESC) sehingga kolom dengan jumlah data kosong terbanyak akan ditampilkan terlebih dahulu


-- Explor Data Analysis (EDA)

-- 1. Analisis 10 film dengan rating tertinggi berdasarkan skor IMDB (imdb_score) dan jumlah vote (imdb_votes) minimal 10.000, diurutkan dari skor tertinggi ke terendah.
SELECT 
    title, 
    release_year, 
    imdb_score, 
    imdb_votes
FROM netflix_titles
WHERE type = 'MOVIE' 
  AND imdb_votes >= 10000 -- error integer karena wakrtu import data file csv semua data diubah menjadi string, sehingga harus diubah menjadi integer terlebih dahulu
ORDER BY imdb_score DESC
LIMIT 10;

-- perbaikan program yang sebelumnya berupa string menajdi integer dan numeric agar bisa diurutkan berdasarkan skor IMDB (imdb_score) dan jumlah vote (imdb_votes) minimal 10.000, diurutkan dari skor tertinggi ke terendah.
-- 1)bersihkan string kosong (aman meskipun kolomnya sudah/belum berubah)
UPDATE netflix_titles 
SET 
    imdb_votes = NULLIF(TRIM(imdb_votes::text), ''),
    imdb_score = NULLIF(TRIM(imdb_score::text), '');

-- 2)Ubah tipe datanya ke INTEGER & NUMERIC
ALTER TABLE netflix_titles 
    ALTER COLUMN imdb_votes TYPE INTEGER USING imdb_votes::numeric::integer,
    ALTER COLUMN imdb_score TYPE NUMERIC USING imdb_score::numeric;
-- berhasil melakukan perubahan tipe data

-- 1a. Analisis 10 film dengan rating tertinggi berdasarkan skor IMDB (imdb_score) dan jumlah vote (imdb_votes) minimal 10.000, diurutkan dari skor tertinggi ke terendah.
SELECT 
    title, 
    release_year, 
    imdb_score, 
    imdb_votes
FROM netflix_titles
WHERE type = 'MOVIE' 
  AND imdb_votes >= 10000
ORDER BY imdb_score DESC, imdb_votes DESC
LIMIT 10;

-- 1b. Analisis 10 show rating tertinggi berdasarkan skor IMDB (imdb_score) dan jumlah vote (imdb_votes) minimal 10.000, diurutkan dari skor terendah ke tertinggi.
SELECT
    title,
    release_year,
    imdb_score,
    imdb_votes
FROM netflix_titles
WHERE type = 'SHOW'
  AND imdb_votes >= 10000
ORDER BY imdb_score DESC, imdb_votes DESC
LIMIT 10;

-- 2a. Analisis 10 film dengan skor IMDB (imdb_score) tertinggi berdasarkan genre tertentu
SELECT
    genres,
    release_year,
    imdb_score,
    imdb_votes
FROM netflix_titles
WHERE type = 'MOVIE'
    AND imdb_votes >= 10000
ORDER BY imdb_score DESC, imdb_votes DESC
LIMIT 10;

-- 2b. Analisis 10 show dengan skor IMDB (imdb_score) tertinggi berdasarkan genre tertentu
SELECT
    genres,
    release_year,
    imdb_score,
    imdb_votes
FROM netflix_titles
WHERE type = 'SHOW'
    AND imdb_votes >= 10000
ORDER BY imdb_score DESC, imdb_votes DESC
LIMIT 10;

-- 3a. Melkaukan klasifikasi konten movie netflix berdasarkan gendre
SELECT
    genres,
    COUNT(*) AS title_count
FROM netflix_titles
WHERE type = 'MOVIE'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;

-- 3b. Melkaukan klasifikasi konten show netflix berdasarkan gendre
SELECT
    genres,
    COUNT(*) AS title_count
FROM netflix_titles
WHERE type = 'SHOW'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;

-- 4A. Melakukan analisis tayangan dengan batasan usia yang paling populer berdasarkan jumlah vote (imdb_votes) minimal 10.000, diurutkan dari skor tertinggi ke terendah.
SELECT 
    type,
    age_certification, 
    COUNT(*) AS total_konten,
    /* IMDb = Mewakili suara penonton umum/masyarakat luas secara global.
    TMDb = Mewakili suara komunitas pecinta film/developer + indikator tren (popularity).*/
    ROUND(AVG(imdb_score), 2) AS avg_imdb_score, -- menggunakan fungsi ROUND untuk membulatkan rata-rata skor IMDB (imdb_score) hingga 2 desimal
    ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM netflix_titles
WHERE type = 'MOVIE'
    AND age_certification != '' --menyaring data null dan string kosong pada kolom age_certification
    AND imdb_votes >= 10000
GROUP BY type,age_certification
ORDER BY type,avg_imdb_score DESC;

-- 4b. Melakukan analisis tayangan dengan batasan usia yang paling populer berdasarkan jumlah vote (imdb_votes) minimal 10.000, diurutkan dari skor tertinggi ke terendah.
SELECT 
    type,
    age_certification, 
    COUNT(*) AS total_konten,
    /* IMDb = Mewakili suara penonton umum/masyarakat luas secara global.
    TMDb = Mewakili suara komunitas pecinta film/developer + indikator tren (popularity).*/
    ROUND(AVG(imdb_score), 2) AS avg_imdb_score, -- menggunakan fungsi ROUND untuk membulatkan rata-rata skor IMDB (imdb_score) hingga 2 desimal
    ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM netflix_titles
WHERE type = 'SHOW'
    AND age_certification != '' --menyaring data null dan string kosong pada kolom age_certification
    AND imdb_votes >= 10000
GROUP BY type,age_certification
ORDER BY type,avg_imdb_score DESC;

-- 5. Analisis apakah durasi film memengaruhi tingkat kepuasan penonton? Berapa durasi ideal (sweet spot) yang bikin rating film paling tinggi?
SELECT 
    CASE 
        WHEN runtime < 60 THEN '< 1 jam'
        WHEN runtime BETWEEN 60 AND 120 THEN '1–2 jam'
        WHEN runtime BETWEEN 121 AND 180 THEN '2–3 jam'
        ELSE '> 3 jam'
    END AS kategori_durasi,
    COUNT(*) AS total_konten,
    ROUND(AVG(imdb_score), 2) AS avg_imdb_score
FROM netflix_titles
WHERE type = 'MOVIE' 
  AND runtime IS NOT NULL 
  AND runtime > 0
GROUP BY kategori_durasi
ORDER BY avg_imdb_score DESC;

--6. Asal negara mana yang paling banyak memproduksi film dan tayangan di Netflix?

-- versi a
SELECT 
    production_countries, 
    COUNT(*) AS total_konten
FROM netflix_titles
WHERE type = 'SHOW'
    AND age_certification != '' --menyaring data null dan string kosong pada kolom age_certification
    AND imdb_votes >= 10000
GROUP BY production_countries
ORDER BY total_konten DESC;

--versi b 
SELECT 
    production_countries, 
    ROUND(AVG(imdb_score), 2) AS avg_imdb_score, -- menggunakan fungsi ROUND untuk membulatkan rata-rata skor IMDB (imdb_score) hingga 2 desimal
    ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score,
    COUNT(*) AS total_konten
FROM netflix_titles
WHERE type = 'SHOW'
    AND age_certification != '' --menyaring data null dan string kosong pada kolom age_certification
    AND imdb_votes >= 10000
GROUP BY production_countries
ORDER BY avg_imdb_score DESC;

-- versi b analisis lebih baik untuk mengetahui asal negara mana yang paling banyak memproduksi film dan tayangan di Netflix dengan memisahkan setiap negara yang ada pada kolom production_countries menggunakan fungsi UNNEST dan string_to_array
SELECT 
    TRIM(negara_terpisah) AS country,
    COUNT(*) AS total_konten,
    ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
    ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM netflix_titles,
     UNNEST(string_to_array(REPLACE(REPLACE(REPLACE(production_countries, '[', ''), ']', ''), '''', ''), ',')) AS negara_terpisah
WHERE production_countries IS NOT NULL 
  AND production_countries != ''
GROUP BY TRIM(negara_terpisah)
HAVING COUNT(*) >= 5 -- Pintu filter: hanya negara dengan minimal 5 konten
ORDER BY avg_imdb_score DESC;

