# ÁGATHA - Sistema de Gestão de Riscos

O Sistema Ágatha – Sistema de Gestão de Integridade, Riscos e Controles consiste em uma ferramenta automatizada, desenvolvida pelo Ministério do Planejamento, Desenvolvimento e Gestão, para auxiliar no processo de gerenciamento de riscos e controle, tendo em vista o item III do Art. 7º, da Portaria GM/MP n° 426, de 2016, que tem como diretriz para a gestão de riscos possibilitar a obtenção de informações úteis à tomada de decisão para a consecução dos objetivos  institucionais e para o gerenciamento e a manutenção dos riscos dentro dos padrões definidos pelas instâncias supervisoras. 

Este repositório consta um build utilizável para o projeto visto que a documentação necessário para a instalação do projeto é complexa. Este projeto utiliza alpine para sua construção base para diminuir o tamanho final do container.

O usuário já deve possuir um ambiente Docker funcional para utilizar este container.

## Aquisição das Chaves

Vale ressaltar que para utilizar este container ainda se faz necessário realizar o pedido para aquisição das chaves afim de realizar a autenticação com o Brasil Cidadão. O procedimento para aquisição das chaves estão disponível no [manual de instalação do Agatha](https://softwarepublico.gov.br/social/articles/0005/2222/Manual_de_Instala__o_Agatha.pdf). 

Informamos que serão necessário a solicitação das chaves em dois momentos, um para ambiente de teste, e a solicitação deverá ser repetidas afim de pedir as chaves para o ambiente de produção do Brasil Cidadão.

## Como utilizar


```bash
docker run --name agatha \
           -p 80:80 -p 443:443 \
           -e ECIDADAO_SERVER=... \
           -v /etc/localtime:/etc/localtime \
           -d lucasdiedrich/agatha
```

Está opção é a mais simples, deve ser repassadas as informações para a conexão com o banco, caso seja necessário levantar um banco de dados utilizada a opção com o docker-compose.

### Docker-compose

Existe um exemplo de docker-compose [docker-compose](./docker-compose.yml), só baixar o arquivo e executar como exemplo abaixo:

```bash
docker-compose up
```

## Versões

Todas as versões deste container podem ser localizadas em [Docker Hub Tags](https://hub.docker.com/r/lucasdiedrich/agatha/tags/).

## Variaveis de inicialização do container

|  Nome  | Valor Padrão | Info |
|:------:|:-------:|:-------:|
| ECIDADAO_ENV |  PROD  | Se utilizará a API de teste do Brasil Cidadão |
| ECIDADAO_SERVER |  MINHAINSTITUICAO.EDU.BR  | Domínio da sua aplicação fornecido na requisição do acesso  |
| ECIDADAO_ID |  MINHAID  | ID fornecido pelo Brasil Cidadão |
| ECIDADAO_SECRET |  MINHAKEY  | SECRET fornecido pelo Brasil Cidadão |
|   DB_CHECK  | 1 | Força a verificação e criação dos schemas necessários no banco de dados |
|   DB_HOST  | agathadb | Database host |
|   DB_USER  | gestaoriscos | Database username |
|   DB_PASSWORD  | gestaoriscos | Database password |
|   DB_NAME  | agatha | Database name |

## Pontos de montagem (Volumes)

|  Volume  | Info |
|:------:|:-------:|
| /config/ | Onde estão localizados os arquivos necessário para configurar do spring |


## SSL

TODO

## License

MIT © [Lucas Diedrich](https://github.com/lucasdiedrich)