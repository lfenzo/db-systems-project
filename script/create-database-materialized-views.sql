CREATE MATERIALIZED VIEW comparison_table AS 
	SELECT
		r.YEAR AS "rec_year",
		p.YEAR aS "pur_year",
		r.MONTH AS "rec_month",
		p.MONTH AS "pur_month",
		r.cpf AS "rec_cpf",
		p.cpf AS "pur_cpf",
		r.product_id AS "rec_product_id",
		p.product_id AS "pur_product_id",
		r.salary_range AS "rec_salary_range",
		p.salary_range AS "pur_salary_range",
		COALESCE(r.product_category, p.product_category) AS "product_category",
		COALESCE(r.product_name, p.product_name) AS "product_name",
		r.quantity AS "recommended",
		p.quantity AS "transacted"
	FROM recommendation_view AS r
	FULL OUTER JOIN purchase_view AS p
	ON r.YEAR = p.YEAR
		AND p.MONTH = r.MONTH
		AND r.cpf = p.cpf
		AND r.product_id = p.product_id
WITH DATA;
