oc exec -it pg-navdb-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database navdb;'"
oc exec -it pg-navdb-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d navdb -c 'create schema postgres;'"
oc exec -it pg-navdb-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d navdb -c 'create schema navdb;'"

oc exec -it pg-bastudio-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database bastudio;'"
oc exec -it pg-bastudio-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d bastudio -c 'create schema postgres;'"

oc exec -it pg-baw-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database bawdos;'"
oc exec -it pg-baw-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d bawdos -c 'create schema postgres;'"
oc exec -it pg-baw-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database bawdocs;'"
oc exec -it pg-baw-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d bawdocs -c 'create schema postgres;'"
oc exec -it pg-baw-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database bawtos;'"
oc exec -it pg-baw-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d bawtos -c 'create schema postgres;'"

oc exec -it pg-objectstores-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database aeos;'"
oc exec -it pg-objectstores-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d aeos -c 'create schema postgres;'"
oc exec -it pg-objectstores-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database fnos1;'"
oc exec -it pg-objectstores-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d fnos1 -c 'create schema postgres;'"
oc exec -it pg-objectstores-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database devos1;'"
oc exec -it pg-objectstores-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d devos1 -c 'create schema postgres;'"

oc exec -it pg-engines-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database appeng;'"
oc exec -it pg-engines-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d appeng -c 'create schema postgres;'"
oc exec -it pg-engines-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database baspbeng;'"
oc exec -it pg-engines-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d baspbeng -c 'create schema postgres;'"

oc exec -it pg-odm-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database odmds;'"
oc exec -it pg-odm-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d odmds -c 'create schema postgres;'"
oc exec -it pg-odm-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database odmdc;'"
oc exec -it pg-odm-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d odmdc -c 'create schema postgres;'"

oc exec -it pg-adp-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database baseca;'"
oc exec -it pg-adp-db-1 -c postgres -- /bin/bash -c "psql -U postgres -d baseca -c 'create schema postgres;'"
oc exec -it pg-adp-db-1 -c postgres -- /bin/bash -c "psql -U postgres -c 'create database adpprj01;'"
