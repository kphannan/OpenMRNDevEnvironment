#!/usr/bin/env bash

## Install ansible to allow for ansible_local
if [[ $INSTALL_ANSIBLE  =~ true || $INSTALL_ANSIBLE =~ 1 || $INSTALL_ANSIBLE =~ yes ]]; then
    yum -y install ansible libselinux-python
fi
