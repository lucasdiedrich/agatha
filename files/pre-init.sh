#!/bin/bash
set -e

APP="/config/application.properties"
APPYAML="/config/application.yaml"
#
# Verificação do banco de dados.
#
if [[ $DB_CHECK -eq "1" ]]; then
    echo "Verificando banco de dados..."
    export PGPASSWORD=$DB_PASSWORD

    CREATE_SCHEMA="psql -U $DB_USER -h $DB_HOST $DB_NAME"

$CREATE_SCHEMA <<SQL
CREATE SCHEMA IF NOT EXISTS gestaoriscos AUTHORIZATION ${DB_USER};
CREATE SCHEMA IF NOT EXISTS aud_gestaoriscos AUTHORIZATION ${DB_USER};
ALTER USER ${DB_USER} SET search_path=gestaoriscos,aud_gestaoriscos,public;
SQL
fi

#
# Verificação de sobreposição dos arquivos de configuração.
#
if [[ -f $APP ]]; then
    sed -i "/spring.datasource.url=/c\spring.datasource.url=jdbc:postgresql://$DB_HOST:5432/$DB_NAME" $APP
    sed -i "/spring.datasource.username=/c\spring.datasource.username=$DB_USER" $APP
    sed -i "/spring.datasource.password=/c\spring.datasource.password=$DB_PASSWORD" $APP
else
    echo "ERRO !!!"
    echo "NÃO FOI POSSIVEL ENCONTRAR O ARQUIVO DE CONFIGURAÇÃO application.properties"
    exit 1
fi
if [[ -f $APPYAML ]]; then
    sed -i "/client-id:/c\  client-id: $ECIDADAO_ID" $APPYAML
    sed -i "/client-secret:/c\  client-secret: $ECIDADAO_SECRET" $APPYAML
    sed -i "/pre-established-redirect-uri:/c\  pre-established-redirect-uri: https://$ECIDADAO_SERVER/gestaoriscos/api/login/openid" $APPYAML
    sed -i "/dominio:/c\    dominio: $ECIDADAO_SERVER" $APPYAML
    sed -i "/redireciona-login-sucesso:/c\    redireciona-login-sucesso: https://$ECIDADAO_SERVER" $APPYAML
    sed -i "/redireciona-logout-sucesso:/c\    redireciona-logout-sucesso:  https://$ECIDADAO_SERVER" $APPYAML

    if [[ $DB_CHECK -eq "PROD" ]]; then
        sed -i "/access-token-uri:/c\  access-token-uri: https://scp.brasilcidadao.gov.br/scp/token" $APPYAML
        sed -i "/user-authorization-uri:/c\  user-authorization-uri: https://scp.brasilcidadao.gov.br/scp/authorize" $APPYAML
    else
        sed -i "/access-token-uri:/c\  access-token-uri: https://testescp-ecidadao.estaleiro.serpro.gov.br/scp/token" $APPYAML
        sed -i "/user-authorization-uri:/c\  user-authorization-uri: https://testescp-ecidadao.estaleiro.serpro.gov.br/scp/authorize" $APPYAML
    fi
else
    echo "ERRO !!!"
    echo "NÃO FOI POSSIVEL ENCONTRAR O ARQUIVO DE CONFIGURAÇÃO application.YAML"
    exit 1
fi

#
# Inicia o Java Server
#
/usr/bin/java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar

exit $?
