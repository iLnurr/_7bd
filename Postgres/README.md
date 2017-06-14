---------------------
Install Postgres on Debian:
1. sudo apt-get update
2. sudo apt-get install postgresql postgresql-client
3. sudo su - postgres
4. createdb book
5. aptitude search postgresql
6. sudo apt-get install postgresql-contrib
7. available extensions: ls /usr/share/postgresql/9.4/extension/
8. psql
9. CREATE EXTENSION tablefunc;
10. check installed extensions: \dx
11. CREATE EXTENSION dict_xsyn;
12. CREATE EXTENSION fuzzystrmatch;
13. CREATE EXTENSION pg_trgm;
14. CREATE EXTENSION cube;
15. check installed extensions: \dx
16. exit from psql: \q
17. stop server: sudo /etc/init.d/postgresql stop

---------------------------------------------

On Debian, PostgreSQL is installed with a default user and default database both called postgres.

Start Postgres
0. start server: sudo /etc/init.d/postgresql start
1. switch to the postgres user: sudo su - postgres 
2. start the PostgreSQL console: psql
3. stop server: sudo /etc/init.d/postgresql stop

Day 1.

1. Connect to created base: psql book
2. look to created indexes: \di