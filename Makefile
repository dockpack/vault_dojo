# For full automation on a Mac just type: make

all: mac_apps provision

provision:
	vagrant up --no-provision
	vagrant provision

mac_apps:
	brew bundle
