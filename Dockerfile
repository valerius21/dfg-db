FROM postgres:latest
WORKDIR /images
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_USER postgres
ENV POSTGRES_DB postgres
RUN apt-get update && apt-get upgrade -y && apt-get install curl unzip -y
RUN curl -L https://unsplash.com/data/lite/latest -o photos.zip
RUN unzip photos.zip && rm photos.zip
COPY *.sql .

# TODO: DB connection refused
RUN psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -a -f create_tables.sql
RUN psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f load-data-server.sql
