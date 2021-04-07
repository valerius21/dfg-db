#!/bin/bash

CONTAINER_NAME='dfg-db-dev'

POSTGRES_PASSWORD='postgres'
POSTGRES_USER='postgres'
POSTGRES_DB='postgres'

docker run --name $CONTAINER_NAME -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -e POSTGRES_USER=$POSTGRES_USER -e POSTGRES_DB=$POSTGRES_DB -p 5432:5432 -d postgres:latest

curl -L https://unsplash.com/data/lite/latest -o photos.zip
unzip photos.zip && rm photos.zip

# copy stuff and insert
# https://stackoverflow.com/questions/34688465/how-do-i-run-a-sql-file-of-inserts-through-docker-run/34688994
echo 'copy files into docker vm'
docker cp ./photos.tsv000 $CONTAINER_NAME:/tmp/photos.tsv000
docker cp ./keywords.tsv000 $CONTAINER_NAME:/tmp/keywords.tsv000
docker cp ./collections.tsv000 $CONTAINER_NAME:/tmp/collections.tsv000
docker cp ./conversions.tsv000 $CONTAINER_NAME:/tmp/conversions.tsv000
docker cp ./colors.tsv000 $CONTAINER_NAME:/tmp/colors.tsv000

docker cp ./create_tables.sql $CONTAINER_NAME:/docker-entrypoint-initdb.d/create_tables.sql
docker cp ./load-data-server.sql $CONTAINER_NAME:/docker-entrypoint-initdb.d/load-data-server.sql

echo 'creating tables'
docker exec -u postgres $CONTAINER_NAME psql $POSTGRES_USER $POSTGRES_DB -a -f docker-entrypoint-initdb.d/create_tables.sql
echo 'copy photo data into db'
docker exec -u postgres $CONTAINER_NAME psql $POSTGRES_USER $POSTGRES_DB -f docker-entrypoint-initdb.d/load-data-server.sql

# cleanup
echo 'cleaning up'
rm *.{tsv000,md}
docker exec -u postgres $CONTAINER_NAME rm -rf /tmp/{photos,keywords,collections,colors}.tsv000
