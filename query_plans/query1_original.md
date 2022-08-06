|QUERY PLAN|
|----------|
|Sort  (cost=20299.57..20299.61 rows=17 width=56) (actual time=1525.307..1535.024 rows=35 loops=1)|
|  Sort Key: c.salary_range, (date_part('year'::text, (rec.date)::timestamp without time zone)), (date_part('month'::text, (rec.date)::timestamp without time zone)), (((count(DISTINCT pur.id))::double precision / (count(DISTINCT rec.id))::double precision)) DESC|
|  Sort Method: quicksort  Memory: 29kB|
|  ->  GroupAggregate  (cost=20291.60..20299.22 rows=17 width=56) (actual time=1471.037..1534.977 rows=35 loops=1)|
|        Group Key: c.salary_range, (date_part('year'::text, (rec.date)::timestamp without time zone)), (date_part('month'::text, (rec.date)::timestamp without time zone))|
|        Filter: (sum(pur.quantity) > 0)|
|        ->  Gather Merge  (cost=20291.60..20297.42 rows=50 width=40) (actual time=1468.235..1501.260 rows=119163 loops=1)|
|              Workers Planned: 2|
|              Workers Launched: 2|
|              ->  Sort  (cost=19291.58..19291.63 rows=21 width=40) (actual time=1456.997..1461.998 rows=39721 loops=3)|
|                    Sort Key: c.salary_range, (date_part('year'::text, (rec.date)::timestamp without time zone)), (date_part('month'::text, (rec.date)::timestamp without time zone))|
|                    Sort Method: external merge  Disk: 1800kB|
|                    Worker 0:  Sort Method: quicksort  Memory: 4002kB|
|                    Worker 1:  Sort Method: quicksort  Memory: 3997kB|
|                    ->  Nested Loop Left Join  (cost=0.99..19291.12 rows=21 width=40) (actual time=12.778..1428.850 rows=39721 loops=3)|
|                          ->  Nested Loop Left Join  (cost=0.28..19021.12 rows=21 width=20) (actual time=0.609..177.483 rows=39721 loops=3)|
|                                ->  Parallel Seq Scan on recommendation rec  (cost=0.00..18947.67 rows=21 width=12) (actual time=0.277..105.522 rows=39721 loops=3)|
|                                      Filter: ((date_part('year'::text, (date)::timestamp without time zone) = ANY ('{2022,2021}'::double precision[])) AND (date_part('month'::text, (date)::timestamp without time zone) >= '5'::double precision) AND (date_part('month'::text, (date)::timestamp without time zone) <= '8'::double precision))|
|                                      Rows Removed by Filter: 293612|
|                                ->  Index Scan using customer_pkey on customer c  (cost=0.28..3.50 rows=1 width=12) (actual time=0.001..0.001 rows=1 loops=119163)|
|                                      Index Cond: (cpf = rec.cpf)|
|                          ->  Nested Loop  (cost=0.71..12.84 rows=1 width=16) (actual time=0.031..0.031 rows=0 loops=119163)|
|                                ->  Index Only Scan using customer_pkey on customer c_1  (cost=0.28..0.31 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=119163)|
|                                      Index Cond: (cpf = c.cpf)|
|                                      Heap Fetches: 0|
|                                ->  Index Scan using purchase_pkey on purchase pur  (cost=0.42..12.51 rows=1 width=16) (actual time=0.029..0.030 rows=0 loops=119163)|
|                                      Index Cond: ((cpf = c_1.cpf) AND (id = rec.id))|
|                                      Filter: ((date_part('year'::text, (rec.date)::timestamp without time zone) = date_part('year'::text, (date)::timestamp without time zone)) AND (date_part('month'::text, (date)::timestamp without time zone) = date_part('month'::text, (rec.date)::timestamp without time zone)))|
|                                      Rows Removed by Filter: 2|
|Planning Time: 15.171 ms|
|Execution Time: 1535.637 ms|


