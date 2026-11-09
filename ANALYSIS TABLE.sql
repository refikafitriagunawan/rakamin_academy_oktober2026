CREATE OR REPLACE TABLE `rakamin-kf-analytics191100.kimia_farma.kf_analisa` AS 
WITH analisa AS (
SELECT
  tr.transaction_id,
  tr.date,
  tr.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  tr.customer_name,
  tr.product_id,
  tr.discount_percentage,
  pr.product_name,
  pr.price AS actual_price,
  -- Menentukan persentase_gross_laba Berdasarkan Skema Harga Obat
  CASE
    WHEN pr.price <= 50000 THEN 0.10
    WHEN pr.price > 50000 AND pr.price <= 100000 THEN 0.15
    WHEN pr.price > 100000 AND pr.price <= 300000 THEN 0.20
    WHEN pr.price > 300000 AND pr.price <= 500000 THEN 0.25
    WHEN pr.price > 500000 THEN 0.30
    ELSE 0.00
  END AS persentase_gross_laba,
  tr.rating AS rating_transaksi
FROM `rakamin-kf-analytics191100.kimia_farma.kf_final_transaction` tr
LEFT JOIN `rakamin-kf-analytics191100.kimia_farma.kf_kantor_cabang` kc
  ON tr.branch_id = kc.branch_id
LEFT JOIN `rakamin-kf-analytics191100.kimia_farma.kf_product` pr
  ON tr.product_id = pr.product_id
)
SELECT
  transaction_id,
  date,
  branch_id,
  branch_name,
  kota,
  provinsi,
  rating_cabang,
  customer_name,
  product_id,
  product_name,
  actual_price,
  discount_percentage,
  persentase_gross_laba,
  -- Pehitungan nett_sales (Harga Obat Setelah Diskon)
  actual_price * (1 - (discount_percentage / 100.0)) AS nett_sales,
  -- Perhitungan nett_profit (Keuntungan Kimia Farma)
  (actual_price * (1 - (discount_percentage / 100.0))) * persentase_gross_laba AS nett_profit,
  rating_transaksi
FROM analisa;
