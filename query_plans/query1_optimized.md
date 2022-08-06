|QUERY PLAN|
|----------|
|Incremental Sort  (cost=36007.98..37285.17 rows=100 width=56) (actual time=323.544..326.516 rows=35 loops=1)|
|  Sort Key: rec_salary_range, rec_year, rec_month, (((count(DISTINCT pur_product_id))::double precision / (count(DISTINCT rec_product_id))::double precision)) DESC|
|  Presorted Key: rec_salary_range, rec_year, rec_month|
|  Full-sort Groups: 2  Sort Method: quicksort  Average Memory: 29kB  Peak Memory: 29kB|
|  ->  GroupAggregate  (cost=35995.11..37280.67 rows=100 width=56) (actual time=276.469..326.464 rows=35 loops=1)|
|        Group Key: rec_salary_range, rec_year, rec_month|
|        Filter: (sum(transacted) > 0)|
|        ->  Sort  (cost=35995.11..36155.24 rows=64053 width=40) (actual time=274.129..293.671 rows=119163 loops=1)|
|              Sort Key: rec_salary_range, rec_year, rec_month|
|              Sort Method: external merge  Disk: 5232kB|
|              ->  Bitmap Heap Scan on comparison_table c  (cost=1661.52..30881.45 rows=64053 width=40) (actual time=28.910..217.523 rows=119163 loops=1)|
|                    Recheck Cond: ((rec_year = ANY ('{2022,2021}'::double precision[])) AND (rec_month >= '5'::double precision) AND (rec_month <= '8'::double precision))|
|                    Heap Blocks: exact=3335|
|                    ->  Bitmap Index Scan on ct_time_index  (cost=0.00..1645.51 rows=64053 width=0) (actual time=27.414..27.414 rows=119163 loops=1)|
|                          Index Cond: ((rec_year = ANY ('{2022,2021}'::double precision[])) AND (rec_month >= '5'::double precision) AND (rec_month <= '8'::double precision))|
|Planning Time: 5.321 ms|
|Execution Time: 327.489 ms|

