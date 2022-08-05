-- optimized query 1
SELECT 
	rec_year AS "year",
	rec_month AS "month",
	rec_salary_range AS "salary_range",
	count(DISTINCT rec_cpf) AS "cpf",
	count(DISTINCT rec_product_id) AS "n_recommended_products",
	count(DISTINCT pur_product_id) AS "n_purchased_products",
	count(DISTINCT pur_product_id)::float /
		count(DISTINCT rec_product_id) AS "mix_adherence"
FROM comparison_table AS C
WHERE rec_year IN (2022, 2021)
	AND rec_month BETWEEN 5 AND 8
GROUP BY year, month, salary_range
HAVING sum(transacted) > 0
ORDER BY salary_range, year, month, mix_adherence DESC;


-- uptimized query 2
SELECT 
	rec_year,
	rec_month,
	product_category,
	sum(recommended) AS "recommended_volume",
	sum(transacted) AS "purchased_volume",
	sum(transacted)::float / sum(recommended) AS "volume_adherence"
FROM comparison_table AS C
WHERE rec_year IN (2019, 2021)
 	AND product_category ILIKE 'frut%'
GROUP BY rec_year, rec_month, product_category
ORDER BY rec_year, rec_month, product_category, volume_adherence DESC;
