-- Perbandingan Pendapatan Kimia Farma dari tahun ke tahun
SELECT EXTRACT(YEAR FROM date) AS tahun,
       COUNT(transaction_id) AS total_transaksi,
       ROUND(SUM(nett_sales)) AS nett_sales,
       ROUND(SUM(nett_profit)) AS nett_profit,
       ROUND(AVG(rating_transaksi), 3) AS avg_rating_transaksi
FROM `rakamin-kf-analytics191100.kimia_farma.kf_analisa`
GROUP BY tahun
ORDER BY tahun;

-- Top 10 Total Transaksi Cabang Provinsi
SELECT provinsi,
       COUNT(transaction_id) AS total_transaksi
FROM `rakamin-kf-analytics191100.kimia_farma.kf_analisa`
GROUP BY provinsi
ORDER BY total_transaksi DESC
LIMIT 10;

-- Top 10 Nett Sales Cabang Provinsi
SELECT provinsi,
       ROUND(SUM(nett_sales)) AS total_nett_sales
FROM `rakamin-kf-analytics191100.kimia_farma.kf_analisa`
GROUP BY provinsi
ORDER BY total_nett_sales DESC
LIMIT 10;

-- Top 5 Cabang Dengan Rating Tertinggi, namun Rating Transaksi Terendah
SELECT branch_id,
       branch_name,
       kota,
       provinsi,
       MAX(rating_cabang) AS rating_cabang,
       ROUND(AVG(rating_transaksi), 3) AS avg_rating_transaksi,
       COUNT(*) AS jumlah_transaksi
FROM `rakamin-kf-analytics191100.kimia_farma.kf_analisa`
GROUP BY branch_id, branch_name, kota, provinsi
ORDER BY rating_cabang DESC, avg_rating_transaksi ASC
LIMIT 5;

-- Indonesia's Geo Map Untuk Total Profit Masing-masing Provinsi
SELECT provinsi,
       ROUND(SUM(nett_profit)) AS total_profit
FROM `rakamin-kf-analytics191100.kimia_farma.kf_analisa`
GROUP BY provinsi
ORDER BY total_profit DESC;