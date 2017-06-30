#!/usr/bin/env bash
set -e
export HOME=/home/vagrant
echo provisioning part deux ...

echo JAVA8

echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list

echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
#sudo apt-get update

sudo dpkg --configure -a

sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install oracle-java8-set-default
sudo apt-get -y install  maven


# Flyway
echo Install Flyway database migration
cd /home/vagrant/
if [[ ! -d ./Flyway ]]; then
    mkdir Flyway && cd Flyway
    wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.2.0/flyway-commandline-4.2.0-linux-x64.tar.gz
    tar xzf flyway-commandline-4.2.0-linux-x64.tar.gz
fi
export PATH=$PATH:$HOME/Flyway/flyway-4.2.0

# spring-security-facelets-taglib mirror
cd $HOME
git clone https://github.com/domdorn/spring-security-facelets-taglib.git
cd spring-security-facelets-taglib
mvn clean install 


# SimpleBLog code
if [[ ! -d ./SimpleBlog ]]; then
    git clone https://github.com/endegraaf/SimpleBlog.git
else
    cd SimpleBlog
    git pull
fi

cd $HOME && sudo chown -R vagrant:vagrant $HOME



# Mysql Local database
echo Create a local Database
mysql --user=root --password=vagrant --execute="DROP DATABASE if exists blog; CREATE DATABASE blog CHARACTER SET utf8;"
mysql --user=root --password=vagrant --execute="GRANT USAGE ON *.* TO 'bloguser'@'localhost';DROP USER 'bloguser'@'localhost';"
mysql --user=root --password=vagrant --execute="CREATE USER 'bloguser'@'localhost' IDENTIFIED BY 'blogpassword';"
mysql --user=root --password=vagrant --execute="GRANT ALL PRIVILEGES ON blog.* TO 'bloguser'@'localhost' WITH GRANT OPTION;"

cd $HOME/SimpleBlog


flyway  -baselineOnMigrate=false -url=jdbc:mysql://localhost/ -schemas=blog -user=bloguser -password=blogpassword -locations=filesystem:src/main/resources/db/migration/ migrate

mvn clean install
mvn tomcat7:run-war



