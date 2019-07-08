[English](#delivering-code-faster) | [Português](#entregando-código-mais-rápido)

# Delivering Code Faster

From all the myriad of tools on the market, two, in particular, that can completely transform your productivity in the development environment. [Vagrant] and [Docker] can turn manual tasks into code! And developers love code! Come to this talk to learn how to test environments mirroring production without needing to have local database installations locked to a specific version.

**TODO: translate from Portuguese**

# Entregando Código Mais Rápido

De toda a miríade de ferramentas no mercado, duas, em particular, podem transformar completamente sua produtividade no ambiente de desenvolvimento. [Vagrant] e [Docker] podem transformar tarefas manuais em código! E os desenvolvedores amam código! Acompanhe esse passo-a-passo para aprender como testar ambientes similares (idênticos) a produção sem precisar ter instalações de banco de dados locais bloqueadas para uma versão específica. Aumente ainda hoje sua velocidade de entrega com esses exemplos de automação.

## Pré-requisitos

Independente da complexidade do ambiente que você queira reproduzir, esta demo só exige a instalação do [Vagrant][vagrant-download] junto com o [Virtualbox][virtualbox-donwload] para os exemplos de máquina virtual e/ou do [Docker][docker-download] para os exemplos de container. Simples assim. Três ferramentas para transformar seu ambiente de desenvolvimento.

## Máquina Virtual

Na maioria das vezes, em ambientes de desenvolvimento, máquinas virtuais são lembradas como os processos chatos de configuração que precisam vários passos para instalar um sistema operacional. E ao final ainda fazer um clone para ter certeza que se der algum problema, pelo menos não precisaria fazer essa primeira parte toda novamente. Realmente isso não é nada produtivo apesar de ser muito útil.

Para entregar código mais rápido, precisamos de produtividade, eficiência! Aqui entra a primeira ferramenta, o [Vagrant]. Ele será responsável por eliminar todo o processo de criação manual de uma máquina com apenas uma linha de comando. Além de facilitar a recriação desta máquina quantas vezes forem necessárias. O provisionamento simples de uma máquina com Ubuntu ou CentOS não demora mais do que um minuto.

Uma das grandes vantagem está na possibilidade de configurar um provisionamento com scripts que garatem um ambiente sempre idêntico, independente de onde está sendo executado, eliminando o maior problema do desenvolvimento:

> _"Funciona na minha máquina!"_

Com a configuração de um único arquivo, o `Vagrantfile`, será possível reproduzir isso em qualquer lugar e transformar seu ambiente em código. Código que pode ser armazenado no repositório facilitando não só a tarefa de um desenvolvedor, mas de todo o time.

A base para utilização do Vagrant é uma _box_. Basicamente é um arquivo pré-configurado com um sistema operacional. Os mais comuns são Ubuntu e CentOS. Além das [_boxes_ oficiais][vagrant-official-boxes], também é possível [compartilhar e utilizar _boxes_ de outros usuários ou oficiais de cada distribuição linux][vagrant-boxes].

Um projeto open source muito famoso é o [Bento][bento-project], que disponibiliza diversas versões de distribuições linux preparadas para diferentes _providers_ como VMware, [Virtualbox], and Parallels. O _provider_ oficial e padrão do Vagrant é o Virtualbox. Visualize [aqui][bento-boxes] todas as _boxes_ disponíveis deste projeto.

Outro projeto que disponibiliza ambientes ainda mais completos com ambientes pré-configurados é o [Vagrantbox.es].

### Tipos de Ambiente

O [Vagrant] tem uma abordagem interessante que permite realizar uma configuração única de uma máquina ou configurar em um mesmo arquivo vários tipos de máquina. Isso abre um mundo de possibilidades.

Considerando um único projeto é possível simular o ambiente mais próximo de produção em uma única máquina, simular um servidor de aplicação e outro de banco de dados para testar a comunicação de seu projeto, ou até mesmo definir uma configuração para cada cliente.

É ideal que todos os clientes tenham a mesma versão de software e de infraestrutura. Mas algo que dificilmente é igual são os dados. Cada cliente tem um ajuste fino ou simplemente o cadastro específico. Ter a facilidade de alterar entre massas de dados específicas de cada um ajuda muito para testar novas funcionalidades e encontrar bugs difícies de simular em um banco local com todos os clientes misturados.

A demonstração a seguir aborda a configuração de [múltuplas máquinas][vagrant-multi-machine]. Neste caso é apenas para facilitar a troca de cada exemplo, mas o conceito serve para diversos cenários do dia-a-dia.

Em ambientes onde é necessário lidar com diversos projetos ao mesmo tempo com diferentes versões de tecnologia, esse tipo de configuração como código torna-se fundamental para ganhar velocidade de desenvolvimento. Desligar um ambiente e ligar outro pronto para uso não gasta mais do que dois minutos, garantindo que tudo está configurado da maneira correta.

### Simulando Ambientes Completos

Como consultor, ou até mesmo dentro de uma grande empresa, lidar com diferentes ambientes e tecnologias pode se tornar uma dor de cabeça para o desenvolvedor. Principalmente quando é necessário instalar diferentes versões de cada tecnologia para cada projeto.

Automatizar a criação de cada ambiente é fundamental para acelerar a entrega do seu software. Fazer configurações manuais toma tempo e pode gerar bugs inesperados. Trocar facilmente entre ambientes precisa ser uma tarefa fácil e segura.

#### Ambiente com Java 6

Este projeto está configurado para montar um ambiente simples que utiliza Java 6 (OpenJDK) e um Tomcat 7, publicando um projeto Maven diretamente neste servidor. Veja que a pasta `target` é a padrão gerada por qualquer projeto Maven. Para simplificar essa demonstração, existe apenas o arquivo `.war`, retirado [deste projeto][github-mavenweb].

Perceba que neste momento a URL [http://192.168.33.10:8080] ainda não funciona (com o Tomcat).

Considerando que esse projeto tem múltiplas configurações, também será necessário especificar o apelido `java6` definido no `Vagrantfile` referente a este projeto Java. Basicamente a configuração deste apelido vai executar o script `scripts/provision-java6-env.sh` para o provisionamento do ambiente. Para criar o ambiente, execute:

```
vagrant up java6
```

Este processo pode levar alguns minutos dependendo da conexão de internet se a box utilizada (`hashicorp/precise64`) ainda não existir localmente. Na animação a seguir, a box já existe localmente, acelerando o processo. A máquina será criada e provisionada (também depende da internet devido a instalação de pacotes).

[![Criando Ambiente Java com Vagrant][image-asciinema-java6]][asciinema-java6]

É isso! Assim que o processo de provisionamento terminar seu ambiente estará pronto para uso. Acesse através do IP configurado o servidor Tomcat, [http://192.168.33.10:8080], ou até mesmo o projeto de exemplo [maven-web].

Uma melhoria para este processo ficar ainda mais rápido é exportar o resultado mínimo do ambiente (Java + Tomcat) para uma _box_ e utilizar esta como base para a automação ([documentação de como criar uma _box_ base][howto-base-box]). Isso evitaria a necessidade de buscar pacotes na internet para instalar a infra focando apenas no seu pronto, o mais importante.

_**Observação:** Antes de continuar, pode ser necessário desligar esta máquina para poupar recursos para o próximo exemplo. Execute `vagrant halt java6` para desligar ou `vagrant destroy java6` para destruir/apagar a VM por completo._

**Mais detalhes:**
- [Instalando versões do Java][install-java]
- [Painel de compatibilidade do Tomcat][tomcat-compatibility]
- [Indo mais a fundo em uma instalação de Tomcat no Ubuntu][tomcat-ubuntu]

### Eliminando Bando de Dados Local

Dados! Boa parte do desenvolvimento ou teste de um software tem alguma ligação com banco de dados. E depender de instalações ou configurações locais, ou até mesmo processos manuais de limpeza ou cadastro de informações podem diminuir consideravelmente sua velocidade de entrega.

Para facilitar esta demonstração, será utilizado o mesmo arquivo de configuração (`Vagrantfile`), utilizando apenas apelidos diferentes para cada ambiente provisionado, `db-world` e `db-pagila`. Estes dois nomes estão relacionados aos bancos de dados de exemplo utilizados. As referencias estão [aqui][article-sample-databases-1] e [aqui][article-sample-databases-2]. Ou se preferir, o link direto para donwload dos bancos de dados [world][db-world-download] e [pagila][db-pagila-download].

Ambos os cenários a seguir serão provisionados utilizando o bancos de dados [PostgreSQL]. Para facilitar a demostração e também o ambiente de desenvolvimento, foram modificados os arquivos `pg_hba.conf` e `postgresql.conf`. Esta configuração é **INSEGURA!**, mas aceitável para ambiente de desenvolvimento onde precisamos de velocidade e produtividade. Basicamente ele permite qualquer tipo de conexão vinda de qualquer IP. Múito útil para fazer conexões SSH e acessar o banco através de ferramentas visuais como o pgAmin.

No primeiro ambiente, `db-world`, será provisionado da forma mais simples, utilizando o mínimo necessário. Esta configuração já é o suficiente para eliminar a instalação local do banco de dados e ganhar a liberdade escolha de qualquer versão sem ter problemas com instalações antigas. Executando o comando a seguinte, uma nova máquina virtual será criada apenas com esta configuração do banco de dados.

```
vagrant up db-world
```

Seguindo o mesmo formato do exemplo anterior, a seguir, uma animação do processo completo de provisionamento, acesso da máquina e consulta do banco de dados.

[![Criando Ambiente PostgreSQL com Vagrant (banco world)][image-asciinema-db-world]][asciinema-db-world]

A seguir, em detalhe, o comando utilizado para acessar o banco onde `vagrant ssh db-world` referencia o acesso à máquina (por ser múltiplo ambiente, sempre será necessário definir o apelido em todos os comandos) e o parâmetro `-c` define um comando que será executado, no caso, `"psql -U postgres -d world"` que acessa o bando `world` utilizando o usuário padrão `postgres`.

```
vagrant ssh db-world -c "psql -U postgres -d world"
```

Para facilitar o acesso ao banco via terminal, alguns comandos úties:

```
\?            # ajuda
\l            # listar bancos
\c [DBNAME]   # conecta no banco desejado
\d            # lista todas tabelas, views e sequences
\q            # sair do psql
```

Até aqui, esta automação já facilitaria muito o dia-a-dia, eliminando muitos processos manuais. Mas imagine que o desenvolvedor ja mexeu demais no ambiente e gostaria de ter ele no estado inicial novamente. A forma mais simples e direta seria destruir e criar o ambiente novamente. Com certeza já seria melhor e mais rápido que os processos manuais. Mas isso pode melhorar.

O [Vagrant] realiza o provisionamento somente na criação da máquina. Mas também é possível forçar um novo provisionamento.

```
vagrant provision db-world
```

Depois de executar este comando vai perceber um novo problema. Este provisionamento não garante o mesmo resultado em uma segunda execução, ou seja, ele não é idempotente.

![db-world - Provision Error][image-db-world-provision-error]

Para entender melhor este conceito, entrar o segundo ambiente, o `db-pagila`. O banco é diferente só para demostrar um cenário diferente mas o conceito importante aqui é mostrar que este provisionamento garante que mesmo depois de N execuções o resultado final será o mesmo. Logo, depois de bagunçar o ambiente, basta provisiona-lo novamente de forma rápida e começar a usar como se nada tivesse acontecido.

Experimente o mesmo processo feito no `db-world`, mas agora utilizando o ambiente `db-pagila`. Se preferir, antes, desligue a máquina executando `vagrant halt db-world`.

```
vagrant up db-pagila
vagrant ssh db-pagila -c "psql -U postgres -d pagila"
vagrant provision db-pagila
```

Veja na animação a seguir o acesso do banco, uma modificação e depois o provisionamento garantindo o estado inicial.

[![Criando Ambiente PostgreSQL com Vagrant (banco pagila)][image-asciinema-db-pagila]][asciinema-db-pagila]

**Fantástico!!** Aqui seu ambiente local já estará muito mais produtivo. Mas da para melhorar ainda mais?! Claro!!!

## Containers

Desconsideranto o cenário de um ambiente completo que simula a instalação de um servidor completo de produção, muitos dos passos vistos anteriormente são fáceis de reproduzir utilizando apenas containers. E a ferramenta mais conhecida para fazer isso é o [Docker].

De forma bem simples, no isolamento de uma máquina virtual, é necessário simular todo o sistema operacional além de todo resto necessário para o ambiente. Enquanto que em um container só é necessário considerar as diferenças entre o Linux e a imagem [Docker], deixando tudo MUITO mais leve e rápido. A imagem a seguir, retirada da [documentação do Docker][docker-docs-vm-container], deixa isso muito claro ([créditos imagem][image-vm-container-src]).

![Docker - Containers e VMs][image-vm-container]

_Nota: Mesmo em sistemas operacionais como Windows e OSX, que por trás dos panos utilizam uma máquina virtual para reproduzir um Linux, o processo ainda sim fica muito rápido._

### Eliminando Bando de Dados Local com Docker

Enquanto ainda é possível reproduzir máquinas virtuais em um processo manual sem código para a criação do ambiente, mesmo que isso seja ruim, a utilização de containers sempre será feita baseada em código. Excelente para ganhar velocidade.

Para criar uma configuração personalizada, será necessário utilizar um arquivo chamado [Dockerfile][dockerfile-reference]. Este arquivo utiliza uma imagem base, que na maioria das vezes será buscada no [DockerHub], junto com os passos necessários para realizar a configuração do ambiente. Em seguida, este código é compilado e transformado em uma nova imagem Docker, pronta para gerar o cenário desejado.

Esta demonstração vai um pouco além permitindo a passagem de argumentos durante a compilação da imagem. Isso permite deixar o cenário ainda mais flexível, como por exemplo, trocar o tipo de script utilizado durante a criação. As possibilidades são muitas de acordo com cada cenário, seja um banco de dados totalmente diferente ou apenas uma carga base para clientes distintos.

Seguindo a mesma linha da demostração com a máquina virtual, os containers serão criados com base no banco de dados PostgreSQL. A partir da [imagem oficial no dockerhub][dockerhub-postgres], muito do que será demonstrado abaixo tem alguma referência a esta página, seja por parâmetros ou melhores práticas de utilização da imagem.

_Importante: Ao contrário das máquinas virtuais, que foi utilizado um endereço de IP fixo, a utilização dos containers fica mais simples apenas com redirecionando as portas, ou seja, o IP será considerado como **localhost**. É possível utilizar IPs mas o redirecionamento de portas garante o mesmo comportamento desta demonstração independente do sistema operacional utilizado._

### Iniciando um Container sem Dockerfile

Visão geral rápida de como iniciar e acessar um container criado com base em uma imagem já existente, seja ela local ou no Dockerhub. Neste caso não será necessário passar pelo processo do build.

Com o comando a seguir, será iniciada uma imagem do postgres na versão `9.6`. Também é possível especificar ainda mais como a versão `9.6.12`. Para conferir todas as versões (_tags_) disponíveis, acesso o [dockerhub oficial desta imagem][dockerhub-postgres].

```
docker container run -d \
  --name pg-test \
  -p 5432:5432 \
  -v pg-test:/var/lib/postgresql/data \
  postgres:9.6
```

Entendendo linha a linha deste comando:
* `docker container run`, também conhecido como `docker run`, executa um comando em um novo container. Se nada for passado ao final, será considerado o [Entrypoint][dockerfile-reference-entrypoint] definido do Dockerfile da imagem utilizada.
* `-d` ou `--detach` executa o container em _background_, imprimindo na tela o ID do container gerado.
* `-name string` associa um nome ao container criado (se nada fora passado aqui, um nome aleatório será gerado).
* `-p` associa a porta local a uma porta do container. Neste caso é a mesma porta.
* `-v` define um volume, local onde se gerencia os dados voláteis do container. Aqui é dado um nome para o volume referenciando ao caminho que foi definido pelo atributo _VOLUME_ do [dockerfile da imagem utilizada][dockerfile-postgres-9.6].
* `postgres:9.6` define o nome e a versão da imagem utilizada. Se a versão não for passada, será considerada a versão _latest_, se existir.
* `\` este é apenas um truque do linux para deixar o comando em mútiplas linhas

Execute o comando a seguir para acessar o banco Postgres criado. Para sair de dentro do banco, execute `\q`.

```
docker container exec -it pg-test psql -U postgres
```

O comando a seguir é muito interessante para ter uma visão geral do seu Docker Host com tudo que está rodando, imagens e volumes, entre outras informações.

```
docker system df -v
```

Outro comando importante para entender o funcionamento do containers é o que mostra os logs. A flag `-f` é opcional mas interessante para travar o terminar no output da aplicação sem ter que executar o comando diversas vezes. Para sair, `CTRL + C`.

```
docker container logs -f pg-test
```

Para remover o container criado, execute o comando a seguir.

```
docker container rm -f pg-test
```

Por fim, o volume criado para este teste também pode ser removido.

```
docker volume rm pg-test
```

### Dockerfile com Banco de Dados Personalizado

Para reproduzir os mesmos bancos demonstrado com Vagrant, foi montado um script especial para cada cenário (carga). Isso é necessário para respeitar as melhores práticas sugeridas na [imagem base do PostgreSQL][dockerhub-postgres] utilizada.

O `Dockerfile` está configurado em 3 partes:
1. Copia os arquivos do diretorio local para a imagem (alguns serão desconsiderados de acordo com o `.dockerignore`).
2. Definir o argumento do build que será utilizado para alternar entre ambientes.
3. Copia o script desejado para o local que a imagem espera, neste caso `/docker-entrypoint-initdb.d`.

Poderia ser feito um `Dockerfile` para cada cenário mas isso deixaria tudo muito repetitivo, levando em conta que apenas o script será alternado. Mas se for necessário maior performance e menor tamanho final, o ideal é copiar exatamente o que é necessário para a execução.

Será necessário uma sequência de comandos da criação até a remoção total do ambiente criado. Serão dois os cenários: `pg-pagila.sh` e `pg-world-1.0.sh`. O primeiro exemplo aborda o banco de dados _world-1.0_.

1. Compila a configuração transformando em uma imagem Docker. Aqui será necessário passar a flag `--build-arg` para alternar entre os dois cenários desta demonstração. O parâmetro `-t` serve para definir um nome (_tag_) para a imagem gerada.
   ```
   docker image build --build-arg SCRIPT=scripts/pg-world-1.0.sh -t pg-world .
   ```

2. Executa o novo container. Aqui foi utilizado um novo parâmetro, `--rm`, que remove o container depois que ele é encerrado. Fique tranquilo que os dados serão mantidos com o volume definido.
   ```
   docker container run -d --rm \
     --name pg-world \
     -p 5432:5432 \
     -v pg-world-data:/var/lib/postgresql/data \
     pg-world
   ```
   Aqui o banco de dados já está pronto para uso. Para acessar via desenvolvimento ou ferramenta gráfica, utilize o IP como `localhost` e a porta como `5432`.

3. Executa consultas diretamente pelo terminal do banco de dados. Para sair, sempre utilizar `\q`.
   ```
   docker container exec -it pg-world psql -U postgres -d world
   ```

4. A partir deste passo já será iniciada a remoção de todo trabalho feito. Pare o continer em execução.
   ```
   docker container stop pg-world
   ```

5. **CUIDADO!** O próximo passo remove o volume de dados do container. Sempre que executar este comando, confira 3 vezes se está certo disso.
   ```
   docker volume rm pg-world-data
   ```

6. Remove a imagem criada pelo _build_.
   ```
   docker image rm pg-world
   ```

Para executar o segundo cenário, basta trocar os nomes e o parâmetro de build.

1. Compila a imagem.
   ```
   docker image build --build-arg SCRIPT=scripts/pg-pagila.sh -t pg-pagila .
   ```

2. Executa um novo container.
   ```
   docker container run -d --rm \
     --name pg-pagila \
     -p 5433:5432 \
     -v pg-pagila-data:/var/lib/postgresql/data \
     pg-pagila
   ```

3. Acessa via terminal o novo banco de dados.
   ```
   docker container exec -it pg-pagila psql -U postgres -d pagila
   ```

4. Para o container. Apaga o container. Apaga a imagem.
   ```
   docker container stop pg-pagila
   docker volume rm pg-pagila-data
   docker image rm pg-pagila
   ```

### Ganhando Produtividade com Docker Compose

Buscando sempre ajustes e melhorias para deixar tudo ainda mais produtivo, mesmo depois de isolar todo o processo com Docker, ainda é possível otimizar a manipulação dos containers do ambiente demostrado. Uma maneira de evitar todas as configurações do comando Docker é através do [Docker Compose]. Continuando no formato de infraestrutura como código, através de um único arquivo, o `docker-compose.yml`, é possível alternar entre os ambientes previamente simulados de forma ainda mais fácil.

Utilizando o Docker Compose para simular o ambiente do banco _world_, basta um simples comando para já ter tudo rodando. Este comando aciona o build da imagem se a mesma ainda não existir e executa um novo container a partir desta imagem gerada em _backgroud_ (devido à flag `-d`).

```
docker-compose up -d pg-world
```

Este comando não aciona o build novamente se a imagem existir. Para forçar esse comportamento, adicione a flag `--build` ao comando anterior.

A execução de comandos dentro do container segue a mesma ideia do Docker, apenas referenciando o apelido do _service_ configurado no arquivo `docker-compose.yml`.

```
docker-compose exec pg-world psql -U postgres -d world
```

Mesma coisa para a visualização dos logs, também com a possibilidade de utilizar a tag `-f` para travar o terminal como explicado anteriormente.

```
docker-compose logs pg-world
```

Para desligar o container é muito simples.

```
docker-compose stop pg-world
```

Mas para remover o container, imagem, network e até mesmo o volume, é possível fazer tudo em apenas um comando. Neste caso não é possível referencia um serviço, limpando tudo configurado no compose. **CUIDADO NOVAMENTE!!** Esse comando remove todos os volumes associados aos serviços.

```
docker-compose down -v -rmi local
```

_Nota: Para ir mais a fundo em todos os comandos disponívels execute `docker-compose -h` ou para um comando específico `docker-compose [COMMAND] -h`._

Por fim, para criar o ambiente do _pagila_ nada muda. Levando em conta que todas as configurações necessárias estão no compose, basta utilizar o alias do serviço para seguindo os mesmos passos previamente mostrados.

```
docker-compose up -d pg-pagila
```

Se nenhum apelido for passado todos os serviços serão iniciados ao mesmo tempo. Visualize a condição de todos os serviços com o comando a seguir.

```
docker-compose ps
```

É isso! Até o momento (na minha experiência) esse é o cenário mais eficiente para transformar a instalação de banco local em um processo super rápido e fácil.

## Ferramenta Gráfica PostgreSQL

Um conteúdo extra muito interessante ao utilizar o PostgreSQL é a ferramenta gráfica e open source [pgAdmin]. Meu maior uso foi com a versão 3. Fantástica e muito boa para facilitar alguns passos quando lidamos com banco de dados. Recentemente lançaram a versão 4 que me parece muito promissora também.

Seguindo a configuração deste projeto você pode criar a conexão do banco com o IP `192.168.33.10`, porta `5432`, no caso do Vagrant. Ou IP `localhost` com a porta `5432` para o banco _world_ ou `5433` para o banco _pagila_.

A seguir duas consultas simples para executar no banco _world_ depois de configurar seu pgAdmin.

```sql
SELECT * FROM city WHERE countrycode = 'BRA' AND district = 'Rio de Janeiro';
```

```sql
SELECT 
  c.code, c.name, l.percentage 
FROM country AS c 
  INNER JOIN countrylanguage AS l ON(c.code=l.countrycode) 
WHERE l.language = 'Portuguese' 
ORDER BY l.percentage DESC;
```

## Problemas / Soluções

* Devido a um problema no script do banco _pagila_, foi necessário modificar o arquivo original `pagila-schema.sql`. O erro a seguir impedia, principalmente no docker, a continuação da execução do script até o final.
   ```
   psql:/var/app/database/pagila-schema.sql:22: ERROR:  language "plpgsql" already exists
   ```
   A seguir a alteração feita no arquivo (linha 21).
   ```sql
   -- antes
   CREATE PROCEDURAL LANGUAGE plpgsql;

   -- depois
   CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;
   ```

[http://192.168.33.10:8080]: http://192.168.33.10:8080
[Docker]: https://docker.com
[Docker Compose]: https://docs.docker.com/compose/
[DockerHub]: https://hub.docker.com/
[maven-web]: http://192.168.33.10:8080/maven-web
[pgAdmin]: https://www.pgadmin.org/
[PostgreSQL]: https://www.postgresql.org
[Vagrant]: https://vagrantup.com
[Vagrantbox.es]: http://www.vagrantbox.es
[Virtualbox]: https://www.virtualbox.org/

[article-sample-databases-1]: https://community.embarcadero.com/article/articles-database/1076-top-3-sample-databases-for-postgresql
[article-sample-databases-2]: http://pgfoundry.org/projects/dbsamples/
[asciinema-java6]: https://asciinema.org/a/242123
[asciinema-db-pagila]: https://asciinema.org/a/242130
[asciinema-db-world]: https://asciinema.org/a/242125
[bento-boxes]: https://app.vagrantup.com/bento
[bento-project]: https://github.com/chef/bento
[db-pagila-download]: http://pgfoundry.org/frs/download.php/1719/pagila-0.10.1.zip
[db-world-download]: http://pgfoundry.org/frs/download.php/527/world-1.0.tar.gz
[docker-docs-vm-container]: https://www.docker.com/resources/what-container
[docker-download]: https://www.docker.com/get-started
[dockerfile-postgres-9.6]: https://github.com/docker-library/postgres/blob/a9610d18de51c189c9d4b0197c408e2e3bfb7917/9.6/Dockerfile#L169
[dockerfile-reference]: https://docs.docker.com/engine/reference/builder/
[dockerfile-reference-entrypoint]: https://docs.docker.com/engine/reference/builder/#entrypoint
[dockerhub-postgres]: https://hub.docker.com/_/postgres
[github-mavenweb]: https://github.com/cyborgdeveloper/maven-web
[howto-base-box]: https://www.vagrantup.com/docs/boxes/base.html
[install-java]: https://openjdk.java.net/install/
[tomcat-compatibility]: http://tomcat.apache.org/whichversion.html
[tomcat-ubuntu]: https://www.digitalocean.com/community/tutorials/install-tomcat-9-ubuntu-1804
[vagrant-boxes]: https://app.vagrantup.com/boxes/search
[vagrant-download]: https://www.vagrantup.com/downloads.html
[vagrant-official-boxes]: https://www.vagrantup.com/docs/boxes.html#official-boxes
[vagrant-multi-machine]: https://www.vagrantup.com/docs/multi-machine/
[virtualbox-donwload]: https://www.virtualbox.org/wiki/Downloads

[image-asciinema-java6]: https://asciinema.org/a/242123.png
[image-asciinema-db-pagila]: https://asciinema.org/a/242130.png
[image-asciinema-db-world]: https://asciinema.org/a/242125.png
[image-db-world-provision-error]: images/db-world-provision-error.png
[image-vm-container]: images/docker-containerized-and-vm.png
[image-vm-container-src]: https://www.docker.com/sites/default/files/d8/2018-11/docker-containerized-and-vm-transparent-bg.png
