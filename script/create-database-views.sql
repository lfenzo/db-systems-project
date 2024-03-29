CREATE VIEW purchase_view AS
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
	ON prod.category = cat.id;


CREATE VIEW recommendation_view AS
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
	ON prod.category = cat.id;
