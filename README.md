Vault Dojo
==========

This repository combines Hashicorp tools to create a Vault on a Consul cluster running on virtual machines, automated with Ansible.

- Packer creates a hardened Centos 7 base image, to download it from the cloud: `vagrant init dockpack/centos7; vagrant up`.
- Vagrant can use this image to create the VMs for Consul and Vault.
- Consul policies are demoed, as well as Vault policies.
- Use the folder `learn-vault` along with your learning on https://learn.hashicorp.com/vault

