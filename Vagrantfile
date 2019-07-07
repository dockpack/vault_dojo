Vagrant.configure("2") do |config|

  # Install required plugins
  required_plugins = %w( vagrant-hostmanager )
  plugin_installed = false
  required_plugins.each do |plugin|
    unless Vagrant.has_plugin?(plugin)
      system "vagrant plugin install #{plugin}"
      plugin_installed = true
    end
  end

  # If new plugins installed, restart Vagrant process
  if plugin_installed === true
    exec "vagrant #{ARGV.join' '}"
  end
  config.vm.box = "centos/7"
  config.vm.box_check_update = true
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  config.vm.graceful_halt_timeout=15

  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.gui = false
    virtualbox.customize ["modifyvm", :id, "--memory", 2028]
    virtualbox.customize ["modifyvm", :id, "--vram", "64"]
  end

  config.vm.define :jumphost, autostart: true, primary: true do |jumphost_config|
    jumphost_config.vm.box = "centos/7"
    jumphost_config.vm.hostname = "jumphost"
    jumphost_config.vm.network "private_network", ip: "192.168.122.5"
    jumphost_config.vm.network "forwarded_port", id: 'ssh', guest: 22, host: 2205, auto_correct: false
    jumphost_config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
    jumphost_config.vm.provider "virtualbox" do |vb|
      vb.name = "jumphost"
    end
  end

  N = 3
  (1..N).each do |server_id|
    config.vm.define "server#{server_id}" do |server|
      server.vm.hostname = "server#{server_id}"
      server.vm.provider "virtualbox" do |vb|
        vb.name = "server#{server_id}"
      end
      server.vm.network "private_network", ip: "192.168.122.#{10+server_id}"
      server.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
      # Only execute once the Ansible provisioner,
      # when all the servers are up and ready.
      if server_id == N
        server.vm.provision :ansible do |ansible|
          ansible.compatibility_mode = "2.0"
          # Disable default limit to connect to all the servers
          ansible.limit = "all"
          ansible_inventory = "inventories/vagrant.ini"
          ansible.galaxy_role_file = "ansible/requirements.yml"
          ansible.galaxy_roles_path = "ansible/roles"
          ansible.playbook = "ansible/vagrant.yml"
          ansible.verbose = "vv"
          ansible.groups = {
            "vault_instances" => ["server1"],
            "consul_instances" => ["server[1:3]"]
          }
        end
      end
    end
  end

end

