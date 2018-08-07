# ÁGATHA - Sistema de Gestão de Riscos

O Sistema Ágatha – Sistema de Gestão de Integridade, Riscos e Controles consiste em uma ferramenta automatizada, desenvolvida pelo Ministério do Planejamento, Desenvolvimento e Gestão, para auxiliar no processo de gerenciamento de riscos e controle, tendo em vista o item III do Art. 7º, da Portaria GM/MP n° 426, de 2016, que tem como diretriz para a gestão de riscos possibilitar a obtenção de informações úteis à tomada de decisão para a consecução dos objetivos  institucionais e para o gerenciamento e a manutenção dos riscos dentro dos padrões definidos pelas instâncias supervisoras. 

Este repositório consta um build utilizável para o projeto visto que a documentação necessário para a instalação do projeto é complexa. Este projeto utiliza alpine para sua construção base para diminuir o tamanho final do container.

## Como utilizar


## Versões

Todas as versões deste container podem ser localizadas em [Docker Hub Tags tab](https://hub.docker.com/r/lucasdiedrich/agatha/tags/).

## Environment Variables

|  NAME  | Default | Info |
|:------:|:-------:|:-------:|
| ECIDADAO_ENV |  PROD  | Se utilizará a API de teste do Brasil Cidadão |
| ECIDADAO_SERVER |  MINHAINSTITUICAO.EDU.BR  | Domínio da sua aplicação fornecido na requisição do acesso  |
| ECIDADAO_ID |  MINHAID  | ID fornecido pelo Brasil Cidadão |
| ECIDADAO_SECRET |  MINHAKEY  | SECRET fornecido pelo Brasil Cidadão |
|   DB_HOST  | agathadb | Database host |
|   DB_USER  | gestaoriscos | Database username |
|   DB_PASSWORD  | gestaoriscos | Database password |
|   DB_NAME  | agatha | Database name |

## Pontos de montagem (Volumes)

|  Volume  | Info |
|:------:|:-------:|
| /config/ | Onde estão localizados os arquivos necessário para configurar do spring |

## Docker-compose

Existe um exemplo de docker-compose [docker-compose](./docker-compose.yml), só baixar o arquivo e executar como exemplo abaixo:

```bash
docker-compose up
```

## SSL

TODO

## License

MIT © [Lucas Diedrich](https://github.com/lucasdiedrich)