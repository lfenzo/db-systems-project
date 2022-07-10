-- consulta 1
SELECT 
	r.YEAR,
	r.MONTH,
	r.salary_range,
	count(DISTINCT r.cpf),
	count(DISTINCT r.product_id) AS "n_recommended_products",
	count(DISTINCT p.product_id) AS "n_purchased_products",
	count(DISTINCT p.product_id)::float /
		count(DISTINCT r.product_id) AS "mix_adherence"
FROM recommendation_mat_view AS r
LEFT JOIN purchase_mat_view AS p
ON r.YEAR = p.YEAR
	AND p.MONTH = r.MONTH
	AND r.cpf = p.cpf
	AND r.product_id = p.product_id 
WHERE r.YEAR IN (2022, 2021)
	AND r.MONTH BETWEEN 5 AND 8
GROUP BY r.YEAR, r.MONTH, r.salary_range
HAVING sum(p.quantity) > 0
ORDER BY r.salary_range, YEAR, MONTH, mix_adherence DESC


-- consulta 2
SELECT 
	r.YEAR,
	r.MONTH,
	r.product_category,
	sum(r.quantity) AS "recommended_volume",
	sum(p.quantity) AS "purchased_volume",
	sum(p.quantity)::float / sum(r.quantity) AS "volume_adherence"
FROM recommendation_mat_view AS r
FULL OUTER JOIN purchase_mat_view AS p
ON r.YEAR = p.YEAR
	AND p.MONTH = r.MONTH
	AND r.cpf = p.cpf
	AND r.product_id = p.product_id 
WHERE r.YEAR IN (2019, 2021)
 	AND r.product_category = 'frutas'
GROUP BY r.YEAR, r.MONTH, r.product_category
ORDER BY YEAR, MONTH, product_category, volume_adherence DESC

