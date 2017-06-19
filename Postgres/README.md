---------------------
Install Postgres on Debian:
1. sudo apt-get update
2. sudo apt-get install postgresql postgresql-client
3. sudo su - postgres
4. createdb book
5. aptitude search postgresql
6. sudo apt-get install postgresql-contrib
7. available extensions: ls /usr/share/postgresql/9.4/extension/
8. psql book
9. CREATE EXTENSION tablefunc;
10. check installed extensions: \dx
11. CREATE EXTENSION dict_xsyn;
12. CREATE EXTENSION fuzzystrmatch;
13. CREATE EXTENSION pg_trgm;
14. CREATE EXTENSION cube;
15. check installed extensions: \dx
16. exit from psql: \q
17. listen all addresses: sudo nano /etc/postgresql/9.4/main/postgresl.conf
change to: listen_addresses = '*'
18. sudo -u postgres psql book
19. ALTER USER postgres with encrypted password 'postgres';
20. sudo nano /etc/postgresql/9.4/main/pg_hba.conf
change to: local   all         postgres                          trust
or change to: local   all         postgres                          md5
trust - anyone who can connect to the server is authorized to access the database
md5 - password-base authentication
21. sudo systemctl restart postgresql.service
22. stop server: sudo /etc/init.d/postgresql stop

---------------------------------------------

seacrh available gui: aptitude search pgadmin
install pgadmin: sudo apt-get install pgadmin3
_____________________________________________


On Debian, PostgreSQL is installed with a default user and default database both called postgres.

Start Postgres
0. start server: sudo /etc/init.d/postgresql start
1. switch to the postgres user: sudo su - postgres 
2. start the PostgreSQL console: psql
3. stop server: sudo /etc/init.d/postgresql stop

Day 1.

1. Connect to created base: psql book
2. look to created indexes: \di
3. look  list of languages: createlang book --list;

Day 3.
1. Список конфигураций текстового поиска: \dF
2. Список словарей текстового поиска: \dFd