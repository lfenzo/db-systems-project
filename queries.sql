-- ``Recuperar a adesão ao mix média dos consumidores por faixa salarial''
SELECT 
	r.YEAR,
	r.MONTH,
	r.product_category,
	sum(p.quantity) AS "recommended_volume",
	sum(r.quantity) AS "purchased_volume",
	sum(p.quantity)::float / sum(r.quantity) AS "volume_adherence"
FROM recommendation_info AS r
FULL OUTER JOIN purchase_info AS p
ON r.YEAR = p.YEAR
	AND p.MONTH = r.MONTH
	AND r.cpf = p.cpf
	AND r.product_id = p.product_id 
WHERE r.YEAR in (2022, 2021)
	AND r.MONTH BETWEEN 5 AND 11
GROUP BY r.YEAR, r.MONTH, r.product_category
HAVING sum(p.quantity) > 0
ORDER BY volume_adherence DESC


-- consulta alternativa
EXPLAIN ANALYZE SELECT 
	r.YEAR,
	r.MONTH,
	r.product_category,
	count(p.quantity)::float / count(r.quantity) AS "mix_adherence",
	sum(p.quantity)::float / sum(r.quantity) AS "volume_adherence"
FROM recommendation_mat_view AS r
FULL outer JOIN purchase_mat_view AS p
ON r.YEAR = p.YEAR
	AND p.MONTH = r.MONTH
	AND r.cpf = p.cpf
	AND r.product_id = p.product_id 
WHERE r.YEAR in (2022, 2021, 2020)
	AND r.MONTH = 4
GROUP BY r.YEAR, r.MONTH, r.product_category
ORDER BY mix_adherence DESC
