# ÁGATHA - Sistema de Gestão de Riscos

O Sistema Ágatha – Sistema de Gestão de Integridade, Riscos e Controles consiste em uma ferramenta automatizada, desenvolvida pelo Ministério do Planejamento, Desenvolvimento e Gestão, para auxiliar no processo de gerenciamento de riscos e controle, tendo em vista o item III do Art. 7º, da Portaria GM/MP n° 426, de 2016, que tem como diretriz para a gestão de riscos possibilitar a obtenção de informações úteis à tomada de decisão para a consecução dos objetivos  institucionais e para o gerenciamento e a manutenção dos riscos dentro dos padrões definidos pelas instâncias supervisoras. 

Neste repositório consta um build utilizável para o projeto, visto que a documentação necessário para a instalação do projeto é complexa. Este projeto utiliza Alpine para sua construção base para diminuir o tamanho final do container.

O usuário já deve possuir um ambiente Docker funcional para utilizar este container. Para maiores informações em relação ao projeto Agatha, acesse este [link](https://softwarepublico.gov.br/social/agatha).

## Aquisição das Chaves

Vale ressaltar que para utilizar este container ainda é necessário realizar o pedido de aquisição das chaves a fim de realizar a autenticação com o Brasil Cidadão. Os procedimentos para aquisição das chaves estão disponíveis no [manual de instalação do Agatha](https://softwarepublico.gov.br/social/articles/0005/2222/Manual_de_Instala__o_Agatha.pdf). 

A solicitação das chaves deverá ser realizada em dois momentos: uma solicitação para ambiente de testes e outra solicitação para o ambiente de produção.

## Como utilizar


```bash
docker run --name agatha \
           -p 8080:80 -p 8443:443 \
           -e ECIDADAO_SERVER=... \
           -v /etc/localtime:/etc/localtime \
           -d lucasdiedrich/agatha
```

Este caso de uso é o mais simples.  Caso seja necessária a utilização de um banco de dados, os parâmetros de conexão ao banco devem ser repassados com docker-compose.

### Docker-compose

Baixe aqui um exemplo de [docker-compose](https://github.com/lucasdiedrich/agatha/blob/master/docker-compose.yml) e execute com o comando abaixo:

```bash
docker-compose up
```

### Criando usuário admin

Dentro do container existe um script para criação do usuário administrador, no Ágatha o usuário administrador possui o perfil de "Núcleo". Sendo assim siga os comandos abaixo para inserir o novo usuário:

```bash
docker exec -it <nome_do_container> create-admin 'Nome do usuário' 'CPF00000000000' 'meuemail@gmail.com'
```

### Carga inicial dos dados do SIORG

Para a inicialização do sistema, é necessário fazer uma pré-carga dos dados de unidades administrativas, o que pode ser feito através do link [http://endereço-do-ambiente/gestaoriscos/api/siorg/importar](http://endereço-do-ambiente/gestaoriscos/api/siorg/importar).

## Versões

Todas as versões deste container podem ser localizadas em [Docker Hub Tags](https://hub.docker.com/r/lucasdiedrich/agatha/tags/).

## Variaveis de inicialização do container

|  Nome  | Valor Padrão | Info |
|:------:|:-------:|:-------:|
| ECIDADAO_ENV |  PROD  | Se utilizará a API de teste do Brasil Cidadão |
| ECIDADAO_SERVER |  MINHAINSTITUICAO.EDU.BR  | Domínio da sua aplicação fornecido na requisição do acesso  |
| ECIDADAO_ID |  MINHAID  | ID fornecido pelo Brasil Cidadão |
| ECIDADAO_SECRET |  MINHAKEY  | SECRET fornecido pelo Brasil Cidadão |
|   CONF_CHECK  | 1 | Força a verificação e configuração dos arquivos do spring, este item deve ser desabilitado caso esteja utilizando seus prórios arquivo montando o volume /config. |
|   DB_CHECK  | 1 | Força a verificação e criação dos schemas necessários no banco de dados |
|   DB_HOST  | agathadb | Database host |
|   DB_USER  | gestaoriscos | Database username |
|   DB_PASSWORD  | gestaoriscos | Database password |
|   DB_NAME  | agatha | Database name |
|   SIORG  | 2981 | Código do Siorg da Instituição |

## Pontos de montagem (Volumes)

|  Volume  | Info |
|:------:|:-------:|
| /config/ | Onde estão localizados os arquivos necessário para configurar do spring |
| /etc/nginx/certificates/cert.pem | Certificado SSL para navegação segura ponto-a-ponto |
| /etc/nginx/certificates/key.pem | Chave SSL para navegação segura ponto-a-ponto |

## License

Este projeto docker utiliza licença MIT © [Lucas Diedrich](https://github.com/lucasdiedrich)

Sobre o licenciamento do software Ágatha deve estar disponível no site do [Software Público Brasileiro](https://softwarepublico.gov.br/social/agatha)
