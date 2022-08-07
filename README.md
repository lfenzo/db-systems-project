# Database Systems Practical Project

This repository contains all the implementation and artifacts regardng the Database Systems Course pratical project. Information with respect to its contents, organization and reproducibility are shown in the sections below.

## Dependencies

Most of the data generation and performance assessment processes rely on Julia `v1.7.3`, the database system artifacts, in the other hand, were implemented with PostgreSQL:

- Artificial Data Generation (`./script/generate_tuples.jl`)
    - [`DataFrames.jl`](https://dataframes.juliadata.org/stable/): general purpose data manipulation utilities 
    - [`CSV.jl`](https://csv.juliadata.org/stable/): CSV file parsing and writting utilities
    - [`StatsBase.jl`](https://juliastats.org/StatsBase.jl/stable/): sampling methods and other statistics utilities

- Performance Assessment and Plotting (`./plots/boxplots.jl`)
    - [`DataFrames.jl`](https://dataframes.juliadata.org/stable/): same as above
    - [`Makie.jl`](https://makie.juliaplots.org/stable/): plotting ecosystem provicing the axis and boxplot implementation used in the visualizations
    - [`Statistics.jl`](https://github.com/JuliaStats/Statistics.jl): general purpose statistics functions for data description

- Database System
    - [`PostgreSQL`](https://www.postgresql.org/): database system used (`v14.0`)
    - [`DBeaver Community Edition`](https://dbeaver.io/): database management system (`v22.1`)

## Repository Organization and Structure

The artifacts in the repository are organized as shown in the table bwlow:

| Directory/File | Description |
|----------------|-------------|
| [`./backup/backup`](https://github.com/lfenzo/db-systems-project/tree/main/backup) | Backup file for the database with all tables and views (except for the materialized view). |
| [`./img/`](https://github.com/lfenzo/db-systems-project/tree/main/img) | Directory containing the relational model picture for the database and the outputs of `plots/boxplots.jl`, when it is executed. |
| [`./plots/boxplot.jl`](https://github.com/lfenzo/db-systems-project/blob/main/plots/boxplots.jl) | Script used to generate the boxplots comparing the execution times of all queries over the different optimization steps employed. Its output pictures live in `./img/`. |
| [`./query_plans/`](https://github.com/lfenzo/db-systems-project/tree/main/query_plans) | Full query plans of all queries (stored as `.md` files for convenience) comparing their initial and optimized versions in terms of execution time and computational cost. |
| [`./script/`](https://github.com/lfenzo/db-systems-project/tree/main/script) | Directory containing all `.sql` query files and instructions to create the database, the tables and both non-materialized and materialized views as well as the initial and optimized versions of the queries. |
| [`./script/generate_tuples.jl`](https://github.com/lfenzo/db-systems-project/blob/main/script/generate_tuples.jl) | Script responsible for performing artificial data generation, its outputs correspond to `.csv` files, one per table, ready to be imported by the DBMS. |
| [`./script/out/`](https://github.com/lfenzo/db-systems-project/tree/main/script/out) | Contains the output `.csv` files produced by the `generate_tuples.jl` script. |


