#!/usr/bin/env bash

##
# VirtualBox
# compiler (gcc) needed to build/install guest_additions
yum -y install gcc kernel-devel

cd /tmp
sudo mount -o loop /home/vagrant/VBoxGuestAdditions_$(cat /home/vagrant/.vbox_version).iso /mnt
sudo sh /mnt/VBoxLinuxAdditions.run
sudo umount /mnt
sudo rm -rf /home/vagrant/VBoxGuestAdditions_*.iso
