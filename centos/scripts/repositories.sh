#!/bin/bash

set -e
set -x

# Disable fastestmirror
#sudo sed -i -e 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf

# install EPEL
#sudo yum -y install https://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#sudo sed -i -e 's/^enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo
#cd /tmp
#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
#sudo rpm -ivh epel-release-latest-6.noarch.rpm

#sudo sed -i "s/^#baseurl/baseurl/" /etc/yum.repos.d/CentOS-Base.repo
#sudo sed -i "s/^mirrorlist/#mirrorlist/" /etc/yum.repos.d/CentOS-Base.repo

# Comment out all mirrorlist and baseurl definitions then uncomment only a baserul at centos.org
#for f in /etc/yum.repos.d/Cent*.repo
#do
#	# Uncomment Centos mirrors in the yum repository configuration
#	#  1st comment all baseurl / mirrorlist lines -- then uncomment only those containing centos.org
#    sudo sed  -i -r -e 's/^(#?)((baseurl|mirrorlist).*)/#\2/' -e 's/^(#?)(baseurl.*centos\.org.*)/\2/' $f
#done


rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

