[English](#deploying-a-java-app-in-one-click) | [Português](#implantando-um-aplicativo-java-em-um-clique)

# Deploying a Java app in one click

**TODO...**

# Implantando um aplicativo Java em um clique

Passo-a-passo de como fazer sua primeira implantação simples de um aplicativo Java. Esta demonstração é a mesma utilizada durante a apresentação.

## Virtualização

Para simular o ambiente de desenvolvimento (futuramente poderá ser também seu ambiente de testes, homologação ou produção), instale o [VirtualBox](https://www.virtualbox.org/wiki/Downloads), opção *Open Source* muito conhecida no mercado para criação de máquinas virtuais. Nada impede de utilizar outras opções pagas como [Parallels](https://www.parallels.com/br) ou [VMware](https://www.vmware.com).

Outro software com instalação necessária é o [Vagrant](https://www.vagrantup.com), também *Open Source*. Ele faz a mágica da automação junto ao VirtualBox.

Considererando o arquivo de configuração padrão do Vagrant, o `Vagrantfile`, já criado no projeto ([clique aqui para visualiza-lo](./Vagrantfile)), basta executar um comando para ter a máquina pronta para uso.

```
vagrant up
```

Acesse a URL `http://192.168.33.10:8080/` antes e depois do processo para conseguir visualizar o Tomcat funcionando. Lembrando que o IP de acesso foi definido no arquivo `Vagrantfile` e a porta `8080` é a padrão do Tomcat.

## Servidor de Automação

Baixe a versão desejada em [jenkins.io](https://jenkins.io/).
Segue abaixo o comando para iniciar o Jenkins através do pacote `.war` alterando a porta padrão para `8180`.

```
java -jar jenkins-2.121.1.war --httpPort=8180
```

Realize o processo de instalação com todos os pacotes sugeridos, ou apenas selecionando os dois _plugins_ necessários para essa demo: `Git` and `Publish Over SSH`.

Na tela inicial do Jenkins, crie um novo job (project) utilizando a opção _New Item_. Como sugestão de nome, **maven-web-deploy**, selecione a opção _Freestyle project_ iniciando a configuração da automação.

## Implantação

### Aplicativo Java

Para a demonstração, um exemplo simples de um aplicativo web Java que utiliza [Apache Maven](https://maven.apache.org) para automatizar o processo de build.

Siga as sessões e opções assinaladas abaixo para configuração do _job_.

* Checkout *(Source Code Management -> Git)*
  ```
  https://github.com/cyborgdeveloper/maven-web
  ```
* Build *(Build -> Invoke top-level Maven targets)*
  ```
  package
  ```

Caso já tenha a instalação do Maven local, não será necessário configurar o Maven, já sendo possível visualizar na opção *Workspace* todo o projeto compilado.

### Configurando Maven

Obrigatório caso não tenha o Maven instalado localmente ou esteja utilizando [Docker](https://www.docker.com/) como instalação do Jenkins.

Acesse: *Global Tool Configuration > Maven > Add Maven.*

Selecione a versão desejada atribuindo a ela um nome.
* Name: `Maven 3.5.2`
* Install from Apache: `3.5.2`

Depois desta configuração será possível selecionar as versões do Maven ao configurar o build do projeto Java.

### Configurando Servidor

Última configuração necessária, defina o acesso à máquina virtual, inicialmente criada na demo.

Acesse: *Configure System > Publish over SSH*

* Key
  ```
  -----BEGIN RSA PRIVATE KEY-----
  MIIEogIBAAKCAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzI
  w+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoP
  kcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2
  hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NO
  Td0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcW
  yLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQIBIwKCAQEA4iqWPJXtzZA68mKd
  ELs4jJsdyky+ewdZeNds5tjcnHU5zUYE25K+ffJED9qUWICcLZDc81TGWjHyAqD1
  Bw7XpgUwFgeUJwUlzQurAv+/ySnxiwuaGJfhFM1CaQHzfXphgVml+fZUvnJUTvzf
  TK2Lg6EdbUE9TarUlBf/xPfuEhMSlIE5keb/Zz3/LUlRg8yDqz5w+QWVJ4utnKnK
  iqwZN0mwpwU7YSyJhlT4YV1F3n4YjLswM5wJs2oqm0jssQu/BT0tyEXNDYBLEF4A
  sClaWuSJ2kjq7KhrrYXzagqhnSei9ODYFShJu8UWVec3Ihb5ZXlzO6vdNQ1J9Xsf
  4m+2ywKBgQD6qFxx/Rv9CNN96l/4rb14HKirC2o/orApiHmHDsURs5rUKDx0f9iP
  cXN7S1uePXuJRK/5hsubaOCx3Owd2u9gD6Oq0CsMkE4CUSiJcYrMANtx54cGH7Rk
  EjFZxK8xAv1ldELEyxrFqkbE4BKd8QOt414qjvTGyAK+OLD3M2QdCQKBgQDtx8pN
  CAxR7yhHbIWT1AH66+XWN8bXq7l3RO/ukeaci98JfkbkxURZhtxV/HHuvUhnPLdX
  3TwygPBYZFNo4pzVEhzWoTtnEtrFueKxyc3+LjZpuo+mBlQ6ORtfgkr9gBVphXZG
  YEzkCD3lVdl8L4cw9BVpKrJCs1c5taGjDgdInQKBgHm/fVvv96bJxc9x1tffXAcj
  3OVdUN0UgXNCSaf/3A/phbeBQe9xS+3mpc4r6qvx+iy69mNBeNZ0xOitIjpjBo2+
  dBEjSBwLk5q5tJqHmy/jKMJL4n9ROlx93XS+njxgibTvU6Fp9w+NOFD/HvxB3Tcz
  6+jJF85D5BNAG3DBMKBjAoGBAOAxZvgsKN+JuENXsST7F89Tck2iTcQIT8g5rwWC
  P9Vt74yboe2kDT531w8+egz7nAmRBKNM751U/95P9t88EDacDI/Z2OwnuFQHCPDF
  llYOUI+SpLJ6/vURRbHSnnn8a/XG+nzedGH5JGqEJNQsz+xT2axM0/W/CRknmGaJ
  kda/AoGANWrLCz708y7VYgAtW2Uf1DPOIYMdvo6fxIB5i9ZfISgcJ/bbCUkFrhoH
  +vq/5CIWxCPp0f85R4qxxQ5ihxJ0YDQT9Jpx4TMss4PSavPaBH3RXow5Ohe+bYoQ
  NE5OgEXk2wVfZczCZpigBKbKZHNYcelXtTt/nP3rsCuGcM4h53s=
  -----END RSA PRIVATE KEY-----
  ```

* *SSH Servers > Add*
  * Name: `local-vagrant`
  * Hostname: `192.168.33.10`
  * Username: `vagrant`
  * Remote Directory: `/vagrant`

Ao final desta configuração, clique no botão `Test Configuration` para se certificar que o acesso à máquina virtual está funcionando corretamente. Com tudo certo, uma mensagem de sucesso será mostrada.

### Realizando o Deploy

Com todas as configurações gerais realizadas, volte ao _job_ criado inicialmente para configurar a cópia do projeto via SSH para a máquina virtual (que depois poderá ser o seu servidor de homologação ou produção).

* *Build > Send files or execute commands over SSH*
  * Selecione na opção *SSH Server* a configuração previamente feita
  * Source files: `target/maven-web.war`
  * Remove prefix: `target`
  * Remote directory: `deploy-$BUILD_NUMBER`  
    (definimos isso na configuração do SSH)
  * Exec command:
    ```
    # copying the app
    sudo cp /vagrant/deploy-$BUILD_NUMBER/maven-web.war /var/lib/tomcat7/webapps/

    # restarting services
    sudo service tomcat7 restart
    ```

Salve a configuração.

Antes de apertar o botão *Build Now*, confira a URL final para perceber que nada funciona, ainda: http://192.168.33.10:8080/maven-web.

### Undeploy

Para reverter o que foi feito, crie um novo _job_ e configure apenas um script de remoção via SSH, seguindo a mesma ideia do que foi feito no momento de deploy.

Acesse: *New Item > "maven-web-undeploy"*.

* *Build > Send files or execute commands over SSH*
  ```
  # deleting the app
  sudo rm -rf /var/lib/tomcat7/webapps/maven-web /var/lib/tomcat7/webapps/maven-web.war
  ```
