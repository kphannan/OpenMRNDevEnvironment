#!/bin/bash

set -e
set -x

if rpm -q --whatprovides kernel | grep -Fqv $(uname -r); then
  rpm -q --whatprovides kernel | grep -Fv $(uname -r) | xargs sudo yum -y remove
fi

sudo yum --enablerepo=epel clean all
sudo yum history new
sudo truncate -c -s 0 /var/log/yum.log


##
# Clean up

if grep -q -i "release 6" /etc/redhat-release
then
  sudo rm /etc/udev/rules.d/70-persistent-net.rules
fi

sudo rm -rf /dev/.udev/
#sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-enp0s3
#sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-eth0


sudo sed -i "s/^NM_CONTROLLED=\"yes\"/NM_CONTROLLED=\"no\"/" /etc/sysconfig/network-scripts/ifcfg-eth0
sudo sed -i "s/^NM_CONTROLLED=yes/NM_CONTROLLED=no/" /etc/sysconfig/network-scripts/ifcfg-eth0
sudo sed -i "s/^ONBOOT=\"no\"/ONBOOT=\"yes\"/" /etc/sysconfig/network-scripts/ifcfg-eth0
sudo sed -i "s/^ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-eth0

sudo yum -y update
sudo yum -y clean all

#rm -rf /tmp/*

echo "Cleanup the /tmp directory"
sudo rm -rf /tmp/*

# Zero out the free space to save space in the final image:
#echo "Zero out free space to save space in the final image"
#sudo dd if=/dev/zero of=/EMPTY bs=1M
#sudo rm -f /EMPTY
