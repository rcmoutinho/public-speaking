#!/bin/bash

apt-get update -y
apt-get install openjdk-6-jdk -y
apt-get install tomcat7 -y

# everything at Vagrantfile root folder will be synced at /vagrant folder, inside the VM
# so, for Maven projects, you can execute you build

# git clone https://github.com/cyborgdeveloper/maven-web.git
# mvn clean package

# coping the .war file to tomcat server
cp /vagrant/target/maven-web.war /var/lib/tomcat7/webapps
