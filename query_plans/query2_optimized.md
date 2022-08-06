|QUERY PLAN|
|----------|
|Incremental Sort  (cost=39822.17..40360.91 rows=1680 width=50) (actual time=375.248..380.951 rows=24 loops=1)|
|  Sort Key: rec_year, rec_month, product_category, (((sum(transacted))::double precision / (sum(recommended))::double precision)) DESC|
|  Presorted Key: rec_year, rec_month, product_category|
|  Full-sort Groups: 1  Sort Method: quicksort  Average Memory: 26kB  Peak Memory: 26kB|
|  ->  Finalize GroupAggregate  (cost=39821.88..40285.31 rows=1680 width=50) (actual time=375.202..380.928 rows=24 loops=1)|
|        Group Key: rec_year, rec_month, product_category|
|        ->  Gather Merge  (cost=39821.88..40213.91 rows=3360 width=42) (actual time=375.190..380.905 rows=72 loops=1)|
|              Workers Planned: 2|
|              Workers Launched: 2|
|              ->  Sort  (cost=38821.86..38826.06 rows=1680 width=42) (actual time=362.575..362.577 rows=24 loops=3)|
|                    Sort Key: rec_year, rec_month, product_category|
|                    Sort Method: quicksort  Memory: 26kB|
|                    Worker 0:  Sort Method: quicksort  Memory: 26kB|
|                    Worker 1:  Sort Method: quicksort  Memory: 26kB|
|                    ->  Partial HashAggregate  (cost=38715.06..38731.86 rows=1680 width=42) (actual time=362.514..362.529 rows=24 loops=3)|
|                          Group Key: rec_year, rec_month, product_category|
|                          Batches: 1  Memory Usage: 73kB|
|                          Worker 0:  Batches: 1  Memory Usage: 73kB|
|                          Worker 1:  Batches: 1  Memory Usage: 73kB|
|                          ->  Parallel Bitmap Heap Scan on comparison_table c  (cost=7899.02..38522.11 rows=15436 width=34) (actual time=57.705..356.098 rows=12450 loops=3)|
|                                Recheck Cond: (rec_year = ANY ('{2019,2021}'::double precision[]))|
|                                Filter: ((product_category)::text ~~* 'frut%'::text)|
|                                Rows Removed by Filter: 122724|
|                                Heap Blocks: exact=3514|
|                                ->  Bitmap Index Scan on ct_time_index  (cost=0.00..7889.76 rows=403854 width=0) (actual time=67.272..67.273 rows=405523 loops=1)|
|                                      Index Cond: (rec_year = ANY ('{2019,2021}'::double precision[]))|
|Planning Time: 2.077 ms|
|Execution Time: 381.178 ms|

