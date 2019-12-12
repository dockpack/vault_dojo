#!/bin/bash -x

rm -rf /usr/local/src/{binutils*,build,bzip*,gcc*,zlib*}
# Make sure udev doesn't block our network
if grep -q -i "release 6" /etc/redhat-release ; then
    rm -f /etc/udev/rules.d/70-persistent-net.rules
    mkdir /etc/udev/rules.d/70-persistent-net.rules
fi
rm -rf /dev/.udev/
if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ] ; then
    sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-eth0
    sed -i "/^UUID/d" /etc/sysconfig/network-scripts/ifcfg-eth0
fi

# remove
yum remove -y audit aic94xx-firmware alsa-firmware alsa-tools-firmware ivtv-firmware  iwl100-firmware iwl105-firmware iwl135-firmware iwl2000-firmware iwl2030-firmware iwl3160-firmware iwl3945-firmware iwl4965-firmware iwl5000-firmware iwl5150-firmware iwl6000-firmware iwl6000g2a-firmware iwl6000g2b-firmware iwl6050-firmware iwl7260-firmware iwl7265-firmware libsysfs

# update packages
#yum update -y
yum clean all

# minimize disk usage
find /var/log/ -name *.log -exec rm -f {} \;
rm -f /var/log/anaconda.syslog
rm -f /var/log/dmesg.old
truncate -s0 /var/log/lastlog
truncate -s0 /var/log/wtmp
truncate -s0 /var/log/messages
truncate -s0 /var/log/lastlog


rm -rf /tmp/vola /tmp/*.gz /tmp/packer-provisioner-ansible-local

case "$PACKER_BUILDER_TYPE" in

  virtualbox-iso|virtualbox-ovf|vmware-iso|vmware-vmx|googlecompute)
      readonly swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
      readonly swappart=$(readlink -f /dev/disk/by-uuid/"$swapuuid")
      /sbin/swapoff "$swappart"
      dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed"
      /sbin/mkswap -U "$swapuuid" "$swappart"
      history -c
      # Zero out the rest of the free space using dd, then delete the written file.
      dd if=/dev/zero of=/EMPTY bs=1M
      rm -f /EMPTY

      # WORKAROUND: remove myself: https://github.com/mitchellh/packer/issues/1536
      rm -f /tmp/script.sh

      # Add `sync` so Packer doesn't quit too early, before the large file is deleted.
      sync
      ;;
  *)
      echo "Done for ${PACKER_BUILDER_TYPE}"
      ;;

esac
