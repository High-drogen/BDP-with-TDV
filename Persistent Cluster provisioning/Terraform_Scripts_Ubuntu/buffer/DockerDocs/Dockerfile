FROM postgres:latest

RUN apt-get update -y \
	&& DEBIAN_FRONTEND=noninteractive \
	&& apt-get install -y sudo \
	&& apt-get install -y vim

COPY ./dump.sql ./