# For full automation on a Mac just type: make

all: mac_apps provision

provision:
	vagrant up --no-provision
	vagrant provision

mac_apps:
	brew bundle
	pip3 install -r requirements.txt

clean:
	vagrant destroy -f
	rm -rf .vagrant
