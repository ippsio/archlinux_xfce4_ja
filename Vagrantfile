# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.name = "archlinuxx-xfce4_ja"
    vb.memory = "2048"
    vb.customize [
      "modifyvm", :id,
      "--vram", "256",
      "--clipboard", "bidirectional",
      "--draganddrop", "bidirectional",
      "--cpus", "2",
      "--ioapic", "on"
    ]
  end
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provision :shell, :path => "./provision.sh", :privileged => false
end

