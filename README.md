# Vagrant-SimpleBlog
A Vagrant based virtual environment for an internal training CI/CD/DevOps and Test automation tooling. 
The purpose of this demo image is: 
- Give a brief introduction on Linux
- Hands-on using Jenkins (pre-installed)
- Hands-on SeleniumBase (pre-installed)

# Instructions for getting started with Vagrant
## Prerequisites
- Oracle VirtualBox
- Vagrant https://www.vagrantup.com/downloads.html

## Start the Vagrant Virtual Machine
- Clone this repo
- Go into the local repository from the step above
- vagrant up --provider=virtualbox
- Now wait for the process to complete

## Open the Virtual machine (debian 8)
- The default username and password is vagrant 
- Jenkins is up and running to validate this use `ps -ef |grep jenkins` from the command line, to access the local Jenkins navigate to http://localhost:8088/ and see the blog.
- Login using the credentials: `alten` and `welkom@alten` as username and password respectively.

## Running the tests 
- refer to the documentation of SeleniumBase on their Github website. https://github.com/seleniumbase/SeleniumBase 

## Support 
- In case of any questions or concerns regarding this VM please contact eric.de.graaf@alten.nl
