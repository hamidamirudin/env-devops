ALTER USER user_name WITH PASSWORD 'new_password';




docker exec -it postgres-local bash
su postgres 
psql
CREATE USER docker;
CREATE DATABASE docker;
GRANT ALL PRIVILEGES ON DATABASE docker TO docker;
