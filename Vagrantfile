# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |multi|
  multi.vm.define :m2r do |config|
    config.vm.box     = "m2r"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    config.vm.host_name = "m2r.local"
    config.vm.network :hostonly, "172.26.66.100"
    config.vm.share_folder "v-root",  "/home/vagrant/current",  "."

    config.vm.customize ["modifyvm", :id, "--memory", 512]
    config.ssh.forward_agent = true
  end
end
