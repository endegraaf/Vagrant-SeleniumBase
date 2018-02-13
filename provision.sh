#!/usr/bin/env bash
set -e
export HOME=/home/vagrant
export SET_VAGRANT_AS_OWNER="sudo chown -R vagrant:vagrant /home/vagrant"

echo  provisioning the Virtual machine

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo echo "deb http://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y libmysqlclient-dev
sudo apt-get install -y git
sudo apt-get install -y firefox-esr #browsers #sudo apt-get install -y google-chrome-stable
sudo apt-get install -y oracle-java8-installer
sudo apt-get install -y oracle-java8-set-default
sudo apt-get install -y maven
sudo apt-get install -y jenkins
sudo apt-get install -y python python-pip 
sudo apt-get install -y python-dev
sudo apt-get install -y curl

#mysql password
debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
sudo apt-get install -y --force-yes mysql-server
sudo dpkg --configure -a

# Mysql Local database
#echo Create a local Database
#mysql --user=root --password=vagrant --execute="DROP DATABASE if exists blog; CREATE DATABASE blog CHARACTER SET utf8;"
#mysql --user=root --password=vagrant --execute="GRANT USAGE ON *.* TO 'bloguser'@'localhost';DROP USER 'bloguser'@'localhost';"
#mysql --user=root --password=vagrant --execute="CREATE USER 'bloguser'@'localhost' IDENTIFIED BY 'blogpassword';"
#mysql --user=root --password=vagrant --execute="GRANT ALL PRIVILEGES ON blog.* TO 'bloguser'@'localhost' WITH GRANT OPTION;"
#flyway  -baselineOnMigrate=true -url=jdbc:mysql://localhost/ -schemas=blog -user=bloguser -password=blogpassword -locations=filesystem:src/main/resources/db/migration/ migrate

git clone https://github.com/seleniumbase/SeleniumBase.git
$SET_VAGRANT_AS_OWNER

cd SeleniumBase

sudo pip install -r requirements.txt --upgrade
sudo python setup.py develop


echo "Jenkins status: " 
sudo /usr/sbin/invoke-rc.d jenkins status

echo "Initial Admin Password" 
sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /home/vagrant/Desktop/initialAdminPasswdJenkins.txt

