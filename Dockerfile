#
# Build com o zip
#
FROM alpine:3.8 AS base
WORKDIR /
ENV MASTER="https://softwarepublico.gov.br/gitlab/agatha/agatha/repository/archive.zip?ref=master"
RUN apk add --update --no-cache unzip curl && \
    curl $MASTER --output archive.zip && \
    unzip archive.zip

#
# Build do frontend (Angular)
#
FROM node:6-alpine AS frontend
WORKDIR /
COPY --from=base /agatha.git /agatha.git
RUN apk add --update --no-cache make gcc g++ python git && \
    cd /agatha.git/codigo-fonte/cliente/ \
    && mkdir bower_components && \
    npm install && \
    npm install -g bower && bower install --allow-root && \ 
    npm run build

#
# Build do backend (Java)
#
FROM maven:3-jdk-8-alpine AS backend
WORKDIR /
COPY --from=base /agatha.git /agatha.git
RUN cd /agatha.git/codigo-fonte/servico/ && \
    mvn -Dmaven.test.failure.ignore -U clean package && ls -lah

#
# Build Final
#
FROM openjdk:8-jdk-alpine
LABEL maintainer="Lucas G. Diedrich <lucas.diedrich@gmail.com>"
WORKDIR /
ENV JAVA_OPTS="-server -Xmx2G -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70" \
    CONF_CHECK="1" \
    DB_CHECK="1" \
    DB_HOST="agathadb" \
    DB_NAME="agatha" \
    DB_USER="gestaoriscos" \
    DB_PASSWORD="gestaoriscos" \
    ECIDADAO_ENV="PROD" \
    ECIDADAO_SERVER="MINHAINSTITUICAO.EDU.BR" \
    ECIDADAO_ID="MINHAID" \
    ECIDADAO_SECRET="MINHAKEY" \
    SIORG="2981"

COPY --from=frontend /agatha.git/codigo-fonte/cliente/dist/ /usr/share/nginx/html/
COPY --from=backend /agatha.git/codigo-fonte/servico/target/app.jar /app.jar
COPY files/ /

RUN apk add --update --no-cache openssl bash nginx supervisor postgresql-client \
    msttcorefonts-installer fontconfig && \
    mkdir -p /etc/nginx/certificates/ /run/nginx/ /run/supervisord/ && \
    openssl req -x509 -nodes -newkey rsa:4096 -keyout /etc/nginx/certificates/key.pem -out /etc/nginx/certificates/cert.pem -subj '/CN=localhost' -days 365 && \
    chmod +x /usr/bin/pre-init /usr/bin/create-admin && \
    rm -rf /var/cache/apk/* && \
    update-ms-fonts && \
    fc-cache -f

VOLUME ["/config"]

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
