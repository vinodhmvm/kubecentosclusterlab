# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_MASTER_NODE = 3
NUM_WORKER_NODE = 3

IP_NW = "192.168.5."
MASTER_IP_START = 10
NODE_IP_START = 20
LB_IP_START = 30

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "base"
  config.vm.box = "centos/7"
  config.vm.box_version = "1905.1"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Provision Master Nodes
  (1..NUM_MASTER_NODE).each do |i|
      config.vm.define "master-#{i}" do |node|
        # Name shown in the GUI
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubernetes-ha-master-#{i}"
            vb.memory = 2048
            vb.cpus = 2
        end
        node.vm.hostname = "master-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{MASTER_IP_START + i}"
        node.vm.network "forwarded_port", guest: 22, host: "#{2710 + i}"

        node.vm.provision "setup-hosts", :type => "shell", :path => "centos/vagrant/setup-hosts.sh" do |s|
          s.args = ["eth1"]
        end
        node.vm.provision "file", source: "centos/sshkey/id_rsa", destination: "./id_rsa"
        node.vm.provision "file", source: "centos/sshkey/id_rsa.pub", destination: "./id_rsa.pub"
        node.vm.provision "setup-necessary-installation", type: "shell", :path => "centos/necessary-install.sh"
        node.vm.provision "install-docker", type: "shell", :path => "centos/install-docker.sh"
        node.vm.provision "setup-dns", type: "shell", :path => "centos/update-dns.sh"
        node.vm.provision "kube-master-necessary-package", type: "shell", :path => "centos/kube-master-install.sh"
        node.vm.provision "allow-bridge-nf-traffic", :type => "shell", :path => "centos/allow-bridge-nf-traffic.sh"
      end
      config.vm.define "master-1" do |node|
        node.vm.provision "master1-installation", type: "shell", :path => "centos/necessary-master1-install.sh"
      end

  end


  # Provision Load Balancer Node
  config.vm.define "loadbalancer" do |node|
    node.vm.provider "virtualbox" do |vb|
        vb.name = "kubernetes-ha-lb"
        vb.memory = 512
        vb.cpus = 1
    end
    node.vm.hostname = "loadbalancer"
    node.vm.network :private_network, ip: IP_NW + "#{LB_IP_START}"
	node.vm.network "forwarded_port", guest: 22, host: 2730

    node.vm.provision "setup-hosts", :type => "shell", :path => "centos/vagrant/setup-hosts.sh" do |s|
      s.args = ["eth1"]
    end
    node.vm.provision "setup-necessary-installation", type: "shell", :path => "centos/necessary-install.sh"
    node.vm.provision "loadbalncer-installation", type: "shell", :path => "centos/loadbalancer-install.sh"
    node.vm.provision "setup-dns", type: "shell", :path => "centos/update-dns.sh"
  end

  # Provision Worker Nodes
  (1..NUM_WORKER_NODE).each do |i|
    config.vm.define "worker-#{i}" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubernetes-ha-worker-#{i}"
            vb.memory = 512
            vb.cpus = 1
        end
        node.vm.hostname = "worker-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{NODE_IP_START + i}"
		node.vm.network "forwarded_port", guest: 22, host: "#{2720 + i}"

        node.vm.provision "setup-hosts", :type => "shell", :path => "centos/vagrant/setup-hosts.sh" do |s|
          s.args = ["eth1"]
        end
        node.vm.provision "setup-necessary-installation", type: "shell", :path => "centos/necessary-install.sh"
        node.vm.provision "setup-dns", type: "shell", :path => "centos/update-dns.sh"
        node.vm.provision "install-docker", type: "shell", :path => "centos/install-docker.sh"
        node.vm.provision "kube-worker-necessary-package", type: "shell", :path => "centos/kube-worker-install.sh"
        node.vm.provision "allow-bridge-nf-traffic", :type => "shell", :path => "centos/allow-bridge-nf-traffic.sh"
    end
  end
end
