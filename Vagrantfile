# -*- mode: ruby -*-
# vi: set ft=ruby :


# Source : xavki - https://www.youtube.com/watch?v=37VLg7mlHu8&list=PLn6POgpklwWqfzaosSgX2XEKpse5VY2v5
numberKnode=2
vmBox="bento/ubuntu-20.04"

Vagrant.configure("2") do |config|
  # master server
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "#{vmBox}"
    kmaster.vm.hostname = "kmaster"
    kmaster.vm.provision "docker"
    kmaster.vm.box_url = "#{vmBox}"
    kmaster.vm.network :private_network, ip: "192.168.56.100"
    kmaster.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--name", "kmaster"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
    end
    config.vm.provision "file", source: "kagnoster.zsh-theme", destination: "~/.oh-my-zsh/themes/kagnoster.zsh-theme"
    config.vm.provision "shell", inline: <<-SHELL
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
      service ssh restart
    SHELL
    kmaster.vm.provision "shell", path: "install_common.sh"
    kmaster.vm.provision "shell", path: "install_master.sh"
  end

  # slave server
  (1..numberKnode).each do |i|
    config.vm.define "knode#{i}" do |knode|
      knode.vm.box = "#{vmBox}"
      knode.vm.hostname = "knode#{i}"
      knode.vm.provision "docker"
      knode.vm.box_url = "#{vmBox}"
      knode.vm.network "private_network", ip: "192.168.56.10#{i}"
      knode.vm.provider "virtualbox" do |v|
        v.name = "knode#{i}"
        v.memory = 1024
        v.cpus = 1
      end
      config.vm.provision "shell", inline: <<-SHELL
        sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
        service ssh restart
      SHELL
      knode.vm.provision "shell", path: "install_common.sh"
      knode.vm.provision "shell", path: "install_node.sh"
    end
  end
end
