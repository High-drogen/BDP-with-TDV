FROM postgres:latest

RUN apt-get update -y \
	&& DEBIAN_FRONTEND=noninteractive \
	&& apt-get install -y sudo \
	&& apt-get install -y vim

COPY ./polycmuql-2019-08-05.sql ./
COPY ./polycmuql-2021-06-21.sql ./

#ADD ./createTable.sql /docker-entrypoint-initdb.d/
#ADD ./init_script.sh /docker-entrypoint-initdb.d/