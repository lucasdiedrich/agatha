# FROM nginx:stable-alpine
FROM openjdk:8-jdk-alpine
LABEL maintainer="Lucas G. Diedrich <lucas.diedrich@gmail.com>"

WORKDIR /

# ENV Variables
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

COPY files/ /

RUN apk add --update --no-cache openssl bash nginx supervisor postgresql-client tar curl && \
    mkdir -p /etc/nginx/certificates/ /usr/share/nginx/html/ /run/nginx/ /run/supervisord/ && \
    curl https://softwarepublico.gov.br/gitlab/agatha/agatha/raw/master/docker/spring/app.jar --output /app.jar && \
    curl https://softwarepublico.gov.br/gitlab/agatha/agatha/raw/master/docker/nginx/dist.tar.gz --output /usr/share/nginx/html/dist.tar.gz && \
    cd /usr/share/nginx/html/ && tar -zxvf dist.tar.gz && \
    openssl req -x509 -nodes -newkey rsa:4096 -keyout /etc/nginx/certificates/key.pem -out /etc/nginx/certificates/cert.pem -subj '/CN=localhost' -days 365 && \
    chmod +x /usr/bin/pre-init /usr/bin/create-admin && \
    apk del --no-cache tar curl && rm -rf /var/cache/apk/* /usr/share/nginx/html/dist.tar.gz

VOLUME ["/config"]

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
