#!/bin/bash

set -e
set -x

# Disable fastestmirror
sudo sed -i -e 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf

# install EPEL
#sudo yum -y install https://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#sudo sed -i -e 's/^enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo
cd /tmp
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
sudo rpm -ivh epel-release-latest-6.noarch.rpm

sudo sed -i "s/^#baseurl/baseurl/" /etc/yum.repos.d/CentOS-Base.repo
sudo sed -i "s/^mirrorlist/#mirrorlist/" /etc/yum.repos.d/CentOS-Base.repo
