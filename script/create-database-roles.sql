-- admin user
CREATE ROLE admin
WITH SUPERUSER;


-- seller role
CREATE ROLE seller
WITH NOINHEIRIT;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO seller;
GRANT INSERT ON purchase TO seller;



-- analyst role
CREATE ROLE analyst
WITH NOINHEIRIT;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
GRANT INSERT ON recommendation TO analyst;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO analyst;

