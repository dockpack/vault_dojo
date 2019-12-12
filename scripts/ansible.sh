#!/bin/bash -eux
major=$(cat /etc/redhat-release | tr -dc '0-9.'|cut -d \. -f1)
if (($major < 8))
then
  # Install EPEL repository.
  yum -y --enablerepo=extras install epel-release
  yum install -y python-pip python-devel

  # Install Ansible.
  yum -y install ansible ansible-doc ansible-lint python-setuptools
  yum -y install python-jmespath || pip install jmespath
fi
