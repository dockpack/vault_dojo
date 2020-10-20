#!/bin/bash -eux
major=$(cat /etc/redhat-release | tr -dc '0-9.'|cut -d \. -f1)
if (($major < 8))
then
  # Install EPEL repository.
  yum -y --enablerepo=extras install epel-release
  yum install -y python-pip python-devel
  yum -y install python-jmespath || pip install jmespath

  # Install Ansible.
  yum -y install ansible ansible-doc ansible-lint python-setuptools
else
  dnf makecache
  dnf install -y epel-release
  dnf makecache
  dnf install -y ansible
fi
