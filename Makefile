# For full automation on a Mac just type: make

help:
	@echo 'available make targets:'
	@grep PHONY: Makefile | cut -d: -f2 | sed '1d;s/^/make/'

all: mac_apps dependencies trust vagrant

.PHONY: homebrew                 # Install Homebrew packagemanager
/usr/local/bin/brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

.PHONY: /Applications/Xcode.app  # Install XCode
/Applications/Xcode.app:
	 xcode-select --install || softwareupdate -i -r -a

.PHONY: mac_apps                 # Install Mac apps
mac_apps: /Applications/Xcode.app /usr/local/bin/brew
	brew bundle
	pip3 install -r requirements.txt

.PHONY: galaxy                   # Install Ansible roles
galaxy:
	(cd ansible && ansible-galaxy install -f -p roles -r roles/requirements.yml)

ansible/files/ssh/trusted-user-ca-keys.pub:
	mkdir -p ansible/files/ssh/
	chmod -R go-rwx ansible/files/ssh/
	ssh-keygen -f ansible/files/ssh/trusted-user-ca-keys -t ed25519 -a 500 -C trusted-user-ca
	mv ansible/files/ssh/trusted-user-ca-keys ~/.ssh/trusted-user-ca
  chmod 400 ~/.ssh/trusted-user-ca

.PHONY: trust                    # Create SSH CA authority
trust: ansible/files/ssh/trusted-user-ca-keys.pub

.PHONY: vagrant                  # Create Consul Vault cluster on vagrant
vagrant: ansible/files/ssh/trusted-user-ca-keys.pub
	vagrant up --no-provision
	vagrant provision

.PHONY: azure-arm                # create VM image for Azure with Packer
azure-arm:
	@echo arm-centos-image
	/usr/local/bin/packer build -force -only=azure-arm packer.json

.PHONY: virtualbox-iso           # build virtualbox image with Packer
virtualbox-iso:
	rm -rf output-virtualbox-iso
	/usr/local/bin/packer build -only=virtualbox-iso packer.json

packer/centos7.box:
	rm -rf output-virtualbox-iso
	/usr/local/bin/packer build -only=virtualbox-iso packer.json

.PHONY: vagrant-box-add          # vagrant box add --name dockpack/centos7
vagrant-box-add: packer/centos7.box
	vagrant box add --force --provider virtualbox --name dockpack/centos7 packer/centos7.box

.PHONY: boxtest                  # test box with virtualbox
boxtest:
	vagrant up --no-provision --provider virtualbox jumphost
	(cd ansible && ./audit.yml)

clean:
	vagrant destroy -f
	rm -rf .vagrant packer/* packer_cache/* output-virtualbox-iso/*
