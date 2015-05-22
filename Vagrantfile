# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
	
	#1st server "開発サーバー"
	config.vm.define :develop do |sv|
		sv.omnibus.chef_version = :latest
		sv.vm.hostname          = "develop"
		sv.vm.box               = "opscode-ubuntu-14.04"
		sv.vm.box_url           = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
		sv.vm.network :private_network, ip: "192.168.33.10"
		# .\applicationディレクトリをVagrantと共有する
		sv.vm.synced_folder "application", "/var/www/application/current",
			id: "vagrant-root",
			:nfs => false,
			:owner => "vagrant",
			:group => "www-data",
			:mount_options => ["dmode=755,fmode=755"]
		
		sv.vm.provision :chef_solo do |chef|
			chef.log_level = "debug"
			chef.cookbooks_path = "./cookbooks"
			chef.json = {
				nginx: {
					docroot: {
						owner: "vagrant",
						group: "vagrant",
						path: "/var/www/application/current/app/webroot",
						force_create: true
					},
					default: {
						fastcgi_params: { CAKE_ENV: "development" }
					},
					test: {
						available: true,
						fastcgi_params: { CAKE_ENV: "test" }
					}
				}
			}
			chef.run_list = %W[
				recipe[apt]
				recipe[phpenv::default]
				recipe[phpenv::composer]
				recipe[phpenv::develop]
				recipe[capistrano]
			]
		end
	end
	
	#2nd server "ＣＩサーバー"
	config.vm.define :ci do |sv|
		sv.omnibus.chef_version = :latest
		sv.vm.hostname          = "ci"
		sv.vm.box               = "opscode-ubuntu-14.04"
		sv.vm.box_url           = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
		sv.vm.network :private_network, ip: "192.168.33.100"
		
		sv.vm.provision :chef_solo do |chef|
			chef.log_level = "debug"
			chef.cookbooks_path = "./cookbooks"
			chef.json = {
				nginx: {
					docroot: {
						path: "/var/lib/jenkins/jobs/blogapp/workspace/app/webroot",
					},
					default: {
						fastcgi_params: { CAKE_ENV: "development" }
					},
					test: {
						available: true,
						fastcgi_params: { CAKE_ENV: "ci" }
					}
				}
			}
			chef.run_list = %w[
				recipe[apt]
				recipe[phpenv::default]
				recipe[phpenv::composer]
				recipe[phpenv::develop]
				recipe[capistrano]
				recipe[jenkins::default]
				recipe[jenkins::plugin]
			]
		end
	end
	
	#2nd server "デプロイサーバー"
	config.vm.define :deploy do |sv|
		sv.omnibus.chef_version = :latest
		sv.vm.hostname          = "deploy"
		sv.vm.box               = "opscode-ubuntu-14.04"
		sv.vm.box_url           = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
		sv.vm.network :private_network, ip: "192.168.33.200"
		
		sv.vm.provision :chef_solo do |chef|
			chef.log_level = "debug"
			chef.cookbooks_path = "./cookbooks"
			chef.json = {
				nginx: {
					docroot: {
						owner: "vagrant",
						group: "vagrant",
						path: "/var/www/application/current/app/webroot",
					},
					default: {
						fastcgi_params: { CAKE_ENV: "production" }
					},
				}
			}
			chef.run_list = %W[
				recipe[apt]
				recipe[phpenv::default]
				recipe[phpenv::composer]
			]
		end
	end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

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
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
