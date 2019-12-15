#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR=/root

case "$PACKER_BUILDER_TYPE" in

    virtualbox-iso|virtualbox-ovf)
    yum install -y bzip2 tar gcc make perl cpp libstdc++-devel kernel-devel kernel-headers

    mkdir -p /tmp/vbox /run/vboxadd
    mount -o loop $HOME_DIR/VBoxGuestAdditions.iso /tmp/vbox;
    sh /tmp/vbox/VBoxLinuxAdditions.run \
        || echo "VBoxLinuxAdditions.run exited $? and is suppressed." \
            "For more read https://www.virtualbox.org/ticket/12479";
    umount /tmp/vbox;
    rm -rf /tmp/vbox;
    rm -f $HOME_DIR/*.iso;
    mkdir /run/vboxadd
    chown vboxadd:bin /run/vboxadd
    chmod 700 /run/vboxadd
    usermod -s /sbin/nologin vboxadd
    yum -y erase gcc make perl cpp libstdc++-devel kernel-devel kernel-headers
    yum -y clean all

    ## https://access.redhat.com/site/solutions/58625 (subscription required)
    # add 'single-request-reopen' so it is included when /etc/resolv.conf is generated
    echo 'RES_OPTIONS="single-request-reopen"' >> /etc/sysconfig/network
    service network restart
    echo 'Slow DNS fix applied (single-request-reopen)'

  ;;

vmware-iso|vmware-vmx)
    yum install -y perl fuse-utils
    mkdir -p /tmp/vmware
    mkdir -p /tmp/vmware-archive
    mount -o loop $HOME_DIR/linux.iso /tmp/vmware
    tar xzf /tmp/vmware/VMwareTools-*.tar.gz -C /tmp/vmware-archive
    /tmp/vmware-archive/vmware-tools-distrib/vmware-install.pl --default
    umount /tmp/vmware;
    rm -rf  /tmp/vmware;
    rm -rf  /tmp/vmware-archive;
    rm -f $HOME_DIR/*.iso;
  ;;

parallels-iso|parallels-pvm)
    mkdir -p /tmp/parallels;
    mount -o loop $HOME_DIR/prl-tools-lin.iso /tmp/parallels;
    /tmp/parallels/install --install-unattended-with-deps \
      || (code="$?"; \
          echo "Parallels tools installation exited $code, attempting" \
          "to output /var/log/parallels-tools-install.log"; \
          cat /var/log/parallels-tools-install.log; \
          exit $code);
    umount /tmp/parallels;
    rm -rf /tmp/parallels;
    rm -f $HOME_DIR/*.iso;

    # Parallels Tools for Linux includes native auto-mount script,
    # which causes losing some of Vagrant-relative shared folders.
    # So, we should disable this behavior.
    # https://github.com/Parallels/vagrant-parallels/issues/325#issuecomment-418727113
    auto_mount_script='/usr/bin/prlfsmountd'
    if [ -f "${auto_mount_script}" ]; then
        echo -e '#!/bin/sh\n'\
        '# Shared folders auto-mount is disabled by Vagrant ' \
        > "${auto_mount_script}"
    fi
    ;;

*)
    echo "No guest additions implemented for ${PACKER_BUILDER_TYPE}"
    ;;

esac
