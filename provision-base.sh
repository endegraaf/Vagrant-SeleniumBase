#!/usr/bin/env bash
set -e

echo provisioning...
sudo apt-get update

sudo apt-get install -y build-essential
sudo apt-get install -y libmysqlclient-dev
sudo apt-get install -y git
sudo apt-get install -y firefox-esr
sudo apt-get install -y google-chrome-stable

#mysql password
debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
sudo apt-get install -y --force-yes mysql-server


# Gecko driver
cd /home/vagrant
if [[ -d ./gecko ]]; then
   echo Gecko directory already exists
else    
    if [[ ! -d ./gecko ]]; then
        mkdir gecko
    fi
    cd gecko
    wget https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-linux64.tar.gz
    tar xvzf geckodriver-v0.16.1-linux64.tar.gz
    sudo cp geckodriver /usr/local/bin
fi

#Chromedriver
cd /home/vagrant

if [[ ./chromedriver ]]; then
   echo Chromedriver directory already exists
else    
    mkdir chromedriver
    cd chromedriver
    wget https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip
    sudo cp chromedriver /usr/local/bin
fi


if [[ ! -d ./SimpleBlog ]]; then
    git clone https://github.com/endegraaf/SimpleBlog.git
else
    cd SimpleBlog
    git pull
    cd ..
fi

sudo chown -R vagrant SimpleBlog

echo Provisioning complete!

