#!/bin/bash -eux

CLEANUP_BUILD_TOOLS="${CLEANUP_BUILD_TOOLS:-false}"

echo "==> Clear out machine id"
#sudo touch /etc/machine-id.tmp && sudo chmod --reference /etc/machine-id /etc/machine_id.tmp && sudo chown --reference /etc/machine-id /etc/machine_id.tmp
#rm -f /etc/machine-id
#sudo mv /etc/machine_id.tmp /etc/machine_id

echo "==> Cleaning up temporary network addresses"
# Make sure udev doesn't block our network
# http://6.ptmc.org/?p=1649
if grep -q -i "release 6" /etc/redhat-release ; then
    rm -f /etc/udev/rules.d/70-persistent-net.rules || true
    mkdir /etc/udev/rules.d/70-persistent-net.rules || true

    for ndev in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`; do
    if [ "`basename $ndev`" != "ifcfg-lo" ]; then
        sudo sed -i '/^HWADDR/d' "$ndev";
        sudo sed -i '/^UUID/d' "$ndev";
    fi
    done
fi
# Better fix that persists package updates: http://serverfault.com/a/485689
touch /etc/udev/rules.d/75-persistent-net-generator.rules
for ndev in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`; do
    if [ "`basename $ndev`" != "ifcfg-lo" ]; then
        sudo sed -i '/^HWADDR/d' "$ndev";
        sudo sed -i '/^UUID/d' "$ndev";
    fi
done
rm -rf /dev/.udev/

DISK_USAGE_BEFORE_CLEANUP=$(df -h)

if [[ $CLEANUP_BUILD_TOOLS  =~ true || $CLEANUP_BUILD_TOOLS =~ 1 || $CLEANUP_BUILD_TOOLS =~ yes ]]; then
    echo "==> Removing tools used to build virtual machine drivers"
    yum -y remove gcc libmpc mpfr cpp kernel-devel kernel-headers
fi

echo "==> Clean up yum cache of metadata and packages to save space"
yum -y --enablerepo='*' clean all

echo "==> Removing temporary files used to build box"
rm -rf /tmp/*

echo "==> Rebuild RPM DB"
rpmdb --rebuilddb
rm -f /var/lib/rpm/__db*

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;

echo '==> Clear out swap and disable until reboot'
set +e
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
set -e
if [ "x${swapuuid}" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    swappart=$(readlink -f /dev/disk/by-uuid/$swapuuid)
    /sbin/swapoff "${swappart}"
    dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

echo '==> Zeroing out empty area to save space in the final image'
# Zero out the free space to save space in the final image.  Contiguous
# zeroed space compresses down to nothing.
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY


# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync

echo "==> Disk usage before cleanup"
echo "${DISK_USAGE_BEFORE_CLEANUP}"

echo "==> Disk usage after cleanup"
df -h




#### Old version of the cleanup script
#!/bin/bash

#set -e
#set -x

#if rpm -q --whatprovides kernel | grep -Fqv $(uname -r); then
#  rpm -q --whatprovides kernel | grep -Fv $(uname -r) | xargs sudo yum -y remove
#fi

#sudo yum --enablerepo=epel clean all
#sudo yum history new
#sudo truncate -c -s 0 /var/log/yum.log


##
# Clean up

#sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-enp0s3
#sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-eth0

### KPH ### move these into a network provisioning script
#sudo sed -i "s/^NM_CONTROLLED=\"yes\"/NM_CONTROLLED=\"no\"/" /etc/sysconfig/network-scripts/ifcfg-eth0
#sudo sed -i "s/^NM_CONTROLLED=yes/NM_CONTROLLED=no/" /etc/sysconfig/network-scripts/ifcfg-eth0
#sudo sed -i "s/^ONBOOT=\"no\"/ONBOOT=\"yes\"/" /etc/sysconfig/network-scripts/ifcfg-eth0
#sudo sed -i "s/^ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-eth0

#sudo yum -y update
#sudo yum -y clean all



