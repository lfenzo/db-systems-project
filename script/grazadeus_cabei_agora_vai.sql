select current_user

select current_database()

set role analyst

select * from salary_range_mix_adherence(2021, 1, 7);
select * from product_category_volume_adherence('frutas', 2021);

REVOKE EXECUTE ON FUNCTION public.salary_range_mix_adherence FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.product_category_volume_adherence FROM PUBLIC;

-- admin user
CREATE ROLE administrador
WITH LOGIN NOINHERIT CREATEDB CREATEROLE;

GRANT select, insert, update, delete ON ALL TABLES IN SCHEMA public TO administrador with grant option;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO administrador with grant option;

-- seller role
CREATE ROLE seller
WITH NOINHERIT;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO seller;
GRANT insert, update, delete ON purchase TO seller;

-- analyst role
CREATE ROLE analyst
WITH NOINHERIT;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
GRANT insert, update, delete ON recommendation TO analyst;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO analyst;

-- customer role
create role customer
with noinherit;

grant select on recommendation to customer;
grant select on product to customer;

-- guest role
create role guest
with noinherit;

grant select on product to guest;


ALTER TABLE category OWNER TO administrador;
ALTER TABLE customer OWNER TO administrador;
ALTER TABLE product OWNER TO administrador;
ALTER TABLE purchase OWNER TO administrador;
ALTER TABLE recommendation OWNER TO administrador;
