CREATE MATERIALIZED VIEW purchase_info AS
	SELECT
		date_part('year', pur."date") AS "year",
		date_part('month', pur."date") AS "month",
		date_part('day', pur."date") AS "day",
		c.cpf,
		c."name" AS "customer_name",
		c.salary_range,
		pur.quantity,
		pur.id AS "product_id",
		prod."name" AS "product_name",
		prod.brand,
		cat.name AS "product_category",
		prod.price
	FROM purchase AS pur
	LEFT JOIN product AS prod
	ON prod.id = pur.id
	LEFT JOIN customer AS c
	ON c.cpf = pur.cpf
	LEFT JOIN category AS cat
	ON prod.category = cat.id
WITH DATA;


CREATE MATERIALIZED VIEW recommendation_info AS
	SELECT
		date_part('year', rec."date") AS "year",
		date_part('month', rec."date") AS "month",
		c.cpf,
		c."name" AS "customer_name",
		c.salary_range,
		rec.quantity,
		rec.id AS "product_id",
		prod."name" AS "product_name",
		prod.brand,
		cat.name AS "product_category",
		prod.price
	FROM recommendation AS rec
	LEFT JOIN product AS prod
	ON prod.id = rec.id
	LEFT JOIN customer AS c
	ON c.cpf = rec.cpf
	LEFT JOIN category AS cat
	ON prod.category = cat.id
WITH DATA;


-- EXPLAIN ANALYZE SELECT 
-- 	r.YEAR,
-- 	r.MONTH,
-- 	r.product_category,
-- 	sum(p.quantity) AS "recommended_volume",
-- 	sum(r.quantity) AS "purchased_volume",
-- 	sum(p.quantity)::float / sum(r.quantity) AS "volume_adherence"
-- FROM (
-- 	SELECT
-- 		date_part('year', rec."date") AS "year",
-- 		date_part('month', rec."date") AS "month",
-- 		c.cpf,
-- 		c."name" AS "customer_name",
-- 		rec.quantity,
-- 		rec.id AS "product_id",
-- 		prod."name" AS "product_name",
-- 		prod.brand,
-- 		cat.name AS "product_category",
-- 		prod.price
-- 	FROM recommendation AS rec
-- 	LEFT JOIN product AS prod
-- 	ON prod.id = rec.id
-- 	LEFT JOIN customer AS c
-- 	ON c.cpf = rec.cpf
-- 	LEFT JOIN category AS cat
-- 	ON prod.category = cat.id
-- ) AS r
-- LEFT JOIN (
-- 	SELECT
-- 		date_part('year', pur."date") AS "year",
-- 		date_part('month', pur."date") AS "month",
-- 		date_part('day', pur."date") AS "day",
-- 		c.cpf,
-- 		c."name" AS "customer_name",
-- 		c.salary_range,
-- 		pur.quantity,
-- 		pur.id AS "product_id",
-- 		prod."name" AS "product_name",
-- 		prod.brand,
-- 		cat.name AS "product_category",
-- 		prod.price
-- 	FROM purchase AS pur
-- 	LEFT JOIN product AS prod
-- 	ON prod.id = pur.id
-- 	LEFT JOIN customer AS c
-- 	ON c.cpf = pur.cpf
-- 	LEFT JOIN category AS cat
-- 	ON prod.category = cat.id
-- ) AS p
-- ON p.MONTH = r.MONTH AND r.YEAR = p.YEAR AND r.cpf = p.cpf AND r.product_id = p.product_id 
-- WHERE r.YEAR = 2022
-- 	AND r.MONTH BETWEEN 5 AND 11
-- GROUP BY r.YEAR, r.MONTH, r.product_category
-- HAVING sum(p.quantity) > 0
-- ORDER BY volume_adherence DESC
