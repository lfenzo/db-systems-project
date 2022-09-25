-- query 1: mix adherence by salary range and time
CREATE OR REPLACE FUNCTION public.salary_range_mix_adherence(_year integer, _month_begin integer, _month_end integer)
	RETURNS TABLE(
		year comparison_table.rec_year%TYPE,
		month comparison_table.rec_month%TYPE,
		salary_range comparison_table.rec_salary_range%TYPE,
		n_customers bigint,
		n_recommended_products bigint,
		n_purchased_products bigint,
		mix_adherence float
	)
	LANGUAGE plpgsql
AS $function$
BEGIN
	IF $2 >= $3 THEN
		RAISE EXCEPTION '_month_begin must be stricly smaller than _month_end';
	END IF;
 	RETURN QUERY EXECUTE '
    	SELECT 
			rec_year AS "year",
			rec_month AS "month",
			rec_salary_range AS "salary_range",
			count(DISTINCT rec_cpf) AS "n_customers",
			count(DISTINCT rec_product_id) AS "n_recommended_products",
			count(DISTINCT pur_product_id) AS "n_purchased_products",
			count(DISTINCT pur_product_id)::float /
				count(DISTINCT rec_product_id) AS "mix_adherence"
		FROM comparison_table AS C
		WHERE rec_year = $1
			AND rec_month BETWEEN $2 AND $3
		GROUP BY year, month, salary_range
		HAVING sum(transacted) > 0
		ORDER BY salary_range, year, month, mix_adherence DESC;
		'
 	USING _year, _month_begin, _month_end;
END
$function$;

-- query 2: volume adherence by product category and time
CREATE OR REPLACE FUNCTION public.product_category_volume_adherence(_product_category varchar, _year integer)
	RETURNS TABLE(
		year comparison_table.rec_year%TYPE,
		month comparison_table.rec_month%TYPE,
		product_category comparison_table.product_category%TYPE,
		recommended_volume bigint,
		purchased_volume bigint,
		volume_adherence float
	)
	LANGUAGE plpgsql
AS $function$
BEGIN
 	RETURN QUERY EXECUTE '
    	SELECT 
			rec_year,
			rec_month,
			product_category,
			sum(recommended) AS "recommended_volume",
			sum(transacted) AS "purchased_volume",
			sum(transacted)::float / sum(recommended) AS "volume_adherence"
		FROM comparison_table AS C
		WHERE rec_year = $1
		 	AND product_category ILIKE $2
		GROUP BY rec_year, rec_month, product_category
		ORDER BY rec_year, rec_month, product_category, volume_adherence DESC;
		'
 	USING _year, _product_category;
END
$function$;
