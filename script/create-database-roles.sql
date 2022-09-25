--
-- admin user
--
CREATE ROLE administrador
WITH LOGIN NOINHERIT CREATEDB CREATEROLE;

REVOKE EXECUTE ON FUNCTION public.salary_range_mix_adherence FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.product_category_volume_adherence FROM PUBLIC;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO administrador WITH GRANT OPTION;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO administrador WITH GRANT OPTION;


--
-- seller role
--
CREATE ROLE seller
WITH NOINHERIT;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO seller;
GRANT INSERT, UPDATE, DELETE ON purchase TO seller;


--
-- analyst role
--
CREATE ROLE analyst
WITH NOINHERIT;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
GRANT INSERT, UPDATE, DELETE ON recommendation TO analyst;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO analyst;


--
-- customer
--
CREATE ROLE customer
WITH NOINHERIT;

GRANT SELECT ON recommendation_view, purchase_view TO customer;
GRANT SELECT ON product, category TO customer;


--
-- guest role
--
CREATE role guest
with noinherit;

GRANT SELECT ON product, category TO guest;


