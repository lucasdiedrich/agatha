# FROM nginx:stable-alpine
FROM openjdk:8-jdk-alpine
LABEL maintainer="Lucas G. Diedrich <lucas.diedrich@gmail.com>"

WORKDIR /

# Postgres Opts
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
    ECIDADAO_SECRET="MINHAKEY" 

COPY files/springconf/application.properties /config/
COPY files/springconf/application.yaml /config/
COPY files/springconf/jasperreports_extension.properties /config/
COPY files/pre-init.sh /usr/bin/pre-init
COPY files/create-admin.sh /usr/bin/create-admin
COPY files/default.conf /etc/nginx/conf.d/
COPY files/proxy.conf /etc/nginx/
COPY files/supervisord.conf /etc/supervisord.conf

RUN apk add --update --no-cache bash nginx supervisor postgresql-client tar curl && \
    mkdir -p /usr/share/nginx/html/ /run/nginx/ /run/supervisord/ /config && \
    curl https://softwarepublico.gov.br/gitlab/agatha/agatha/raw/master/docker/spring/app.jar --output /app.jar && \
    curl https://softwarepublico.gov.br/gitlab/agatha/agatha/raw/master/docker/nginx/dist.tar.gz --output /usr/share/nginx/html/dist.tar.gz && \
    cd /usr/share/nginx/html/ && tar -zxvf dist.tar.gz && chmod +x /usr/bin/pre-init /usr/bin/create-admin && \
    apk del --no-cache curl tar && rm -rf /var/cache/apk/* /usr/share/nginx/html/dist.tar.gz

VOLUME ["/config"]

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
