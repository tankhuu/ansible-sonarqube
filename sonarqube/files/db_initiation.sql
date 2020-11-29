CREATE DATABASE sonarqube;
CREATE USER sonar;
ALTER USER sonar WITH PASSWORD "{{ db_password }}";
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
