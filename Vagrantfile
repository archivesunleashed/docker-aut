# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.vm.provider "virtualbox" do |v|
    v.name = "Warcbase workshop VM"
  end
  config.vm.hostname = "warcbase"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  config.vm.network :forwarded_port, guest: 8080, host: 9000 # Spark Notebook

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", '2056']
    vb.customize ["modifyvm", :id, "--cpus", "2"]   
  end

  config.vm.provision :shell, inline: "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile", :privileged =>false
  config.vm.provision :shell, path: "./scripts/bootstrap.sh"
  config.vm.provision :shell, path: "./scripts/warcbase.sh", :privileged =>false

end
