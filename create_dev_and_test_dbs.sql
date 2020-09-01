CREATE ROLE health_api WITH LOGIN PASSWORD 'health_api'  CREATEDB;

CREATE DATABASE health_api_development;
CREATE DATABASE health_api_test;

GRANT ALL PRIVILEGES ON DATABASE "health_api_development" to health_api;
GRANT ALL PRIVILEGES ON DATABASE "health_api_test" to health_api;
