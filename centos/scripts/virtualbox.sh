#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    if [ "$INSTALL_GUEST_ADDITIONS" = "true" ] || [ "$INSTALL_GUEST_ADDITIONS" = "1" ]; then
        echo "==> Installing VirtualBox guest additions"
        # Assume that we've installed all the prerequisites:
        # kernel-headers-$(uname -r) kernel-devel-$(uname -r) gcc make perl
        # from the install media via ks.cfg

        VBOX_VERSION=$(cat $SSH_USER_HOME/.vbox_version)
        mount -o loop $SSH_USER_HOME/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
        sh /mnt/VBoxLinuxAdditions.run --nox11
        umount /mnt
        rm -rf $SSH_USER_HOME/VBoxGuestAdditions_$VBOX_VERSION.iso
        rm -f $SSH_USER_HOME/.vbox_version
    fi
fi


