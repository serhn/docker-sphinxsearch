# Dockerfile for Sphinx SE
# https://hub.docker.com/_/alpine/
FROM alpine:3.18


# install dependencies
RUN apk --no-cache --update add sphinx

# set up and expose directories
RUN mkdir -pv /opt/sphinx/logs /opt/sphinx/indexes
VOLUME /opt/sphinx/indexes

RUN indexer -v

# redirect logs to stdout
RUN ln -sv /dev/stdout /opt/sphinx/logs/query.log \
    	&& ln -sv /dev/stdout /opt/sphinx/logs/searchd.log

# expose TCP port
EXPOSE 36307

VOLUME /etc/sphinx/

# allow custom config file to be passed
ARG SPHINX_CONFIG_FILE=/etc/sphinx/sphinx.conf
ENV SPHINX_CONFIG_FILE ${SPHINX_CONFIG_FILE}

# prepare a start script
RUN echo "exec searchd --nodetach --config \${SPHINX_CONFIG_FILE}" > /opt/sphinx/start.sh

CMD sh /opt/sphinx/start.sh
