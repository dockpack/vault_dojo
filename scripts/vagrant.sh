#!/bin/bash -e

case "$PACKER_BUILDER_TYPE" in

  virtualbox-iso|virtualbox-ovf|vmware-iso|vmware-vmx|parallels-iso|parallels-pvm)

    # create vagrant user and group
    /usr/sbin/groupadd vagrant
    /usr/sbin/useradd vagrant -g vagrant -G wheel -d /home/vagrant -c "vagrant"
    # add vagrant's public key - user can ssh without password
    mkdir -pm 700 /home/vagrant/.ssh
    curl -s -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
    chmod 0600 /home/vagrant/.ssh/authorized_keys
    chown -R vagrant:vagrant /home/vagrant/.ssh
    restorecon -R -v /home/vagrant/.ssh

    # give sudo access (grants all permissions to user vagrant)
    echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
    chmod 0440 /etc/sudoers.d/vagrant

    # set password
    echo "vagrant" | passwd --stdin vagrant
    chage -d today vagrant
    chage --mindays 7 vagrant
    chage --maxdays 90 vagrant
    ;;

  *)
    echo "No vagrant semantics implemented for ${PACKER_BUILDER_TYPE}"
    ;;
esac
