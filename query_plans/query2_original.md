|QUERY PLAN|
|----------|
|Sort  (cost=14809.26..14809.40 rows=55 width=556) (actual time=1257.165..1268.421 rows=24 loops=1)|
|  Sort Key: (date_part('year'::text, (rec.date)::timestamp without time zone)), (date_part('month'::text, (rec.date)::timestamp without time zone)), cat.name, (((sum(pur.quantity))::double precision / (sum(rec.quantity))::double precision)) DESC|
|  Sort Method: quicksort  Memory: 26kB|
|  ->  Finalize GroupAggregate  (cost=14789.24..14807.67 rows=55 width=556) (actual time=1253.747..1268.397 rows=24 loops=1)|
|        Group Key: (date_part('year'::text, (rec.date)::timestamp without time zone)), (date_part('month'::text, (rec.date)::timestamp without time zone)), cat.name|
|        ->  Gather Merge  (cost=14789.24..14804.78 rows=110 width=548) (actual time=1253.556..1268.361 rows=72 loops=1)|
|              Workers Planned: 2|
|              Workers Launched: 2|
|              ->  Partial GroupAggregate  (cost=13789.22..13792.06 rows=55 width=548) (actual time=1244.302..1247.494 rows=24 loops=3)|
|                    Group Key: (date_part('year'::text, (rec.date)::timestamp without time zone)), (date_part('month'::text, (rec.date)::timestamp without time zone)), cat.name|
|                    ->  Sort  (cost=13789.22..13789.51 rows=116 width=540) (actual time=1244.146..1244.898 rows=12450 loops=3)|
|                          Sort Key: (date_part('year'::text, (rec.date)::timestamp without time zone)), (date_part('month'::text, (rec.date)::timestamp without time zone)), cat.name|
|                          Sort Method: quicksort  Memory: 1521kB|
|                          Worker 0:  Sort Method: quicksort  Memory: 1294kB|
|                          Worker 1:  Sort Method: quicksort  Memory: 1257kB|
|                          ->  Nested Loop Left Join  (cost=6.45..13785.24 rows=116 width=540) (actual time=4.815..1234.016 rows=12450 loops=3)|
|                                ->  Nested Loop Left Join  (cost=5.74..12754.88 rows=116 width=532) (actual time=0.704..220.357 rows=12450 loops=3)|
|                                      ->  Hash Join  (cost=5.46..12719.86 rows=116 width=532) (actual time=0.657..187.600 rows=12450 loops=3)|
|                                            Hash Cond: (rec.id = prod.id)|
|                                            ->  Parallel Seq Scan on recommendation rec  (cost=0.00..12697.67 rows=4167 width=16) (actual time=0.283..165.088 rows=135174 loops=3)|
|                                                  Filter: (date_part('year'::text, (date)::timestamp without time zone) = ANY ('{2019,2021}'::double precision[]))|
|                                                  Rows Removed by Filter: 198159|
|                                            ->  Hash  (cost=5.41..5.41 rows=4 width=520) (actual time=0.325..0.327 rows=14 loops=3)|
|                                                  Buckets: 1024  Batches: 1  Memory Usage: 9kB|
|                                                  ->  Hash Join  (cost=1.46..5.41 rows=4 width=520) (actual time=0.311..0.321 rows=14 loops=3)|
|                                                        Hash Cond: (prod.category = cat.id)|
|                                                        ->  Seq Scan on product prod  (cost=0.00..3.51 rows=151 width=8) (actual time=0.011..0.025 rows=151 loops=3)|
|                                                        ->  Hash  (cost=1.45..1.45 rows=1 width=520) (actual time=0.258..0.258 rows=1 loops=3)|
|                                                              Buckets: 1024  Batches: 1  Memory Usage: 9kB|
|                                                              ->  Seq Scan on category cat  (cost=0.00..1.45 rows=1 width=520) (actual time=0.244..0.246 rows=1 loops=3)|
|                                                                    Filter: ((name)::text ~~* 'frut%'::text)|
|                                                                    Rows Removed by Filter: 35|
|                                      ->  Index Only Scan using customer_pkey on customer c  (cost=0.28..0.30 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=37350)|
|                                            Index Cond: (cpf = rec.cpf)|
|                                            Heap Fetches: 0|
|                                ->  Nested Loop  (cost=0.71..8.86 rows=1 width=16) (actual time=0.080..0.080 rows=0 loops=37350)|
|                                      ->  Index Only Scan using customer_pkey on customer c_1  (cost=0.28..0.31 rows=1 width=4) (actual time=0.001..0.002 rows=1 loops=37350)|
|                                            Index Cond: (cpf = c.cpf)|
|                                            Heap Fetches: 0|
|                                      ->  Index Scan using purchase_pkey on purchase pur  (cost=0.42..8.54 rows=1 width=16) (actual time=0.078..0.078 rows=0 loops=37350)|
|                                            Index Cond: ((cpf = c_1.cpf) AND (id = rec.id))|
|                                            Filter: ((date_part('year'::text, (rec.date)::timestamp without time zone) = date_part('year'::text, (date)::timestamp without time zone)) AND (date_part('month'::text, (date)::timestamp without time zone) = date_part('month'::text, (rec.date)::timestamp without time zone)))|
|                                            Rows Removed by Filter: 2|
|Planning Time: 13.032 ms|
|Execution Time: 1268.851 ms|

