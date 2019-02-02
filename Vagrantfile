# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.name = "arch"
    vb.memory = "2048"

    vb.customize ["modifyvm", :id, "--vram", "256"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]

    # CLIPBOARD AND DRAG-DROP
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]

    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    # SOUND
    vb.customize ["modifyvm", :id, "--audioout", "on"]
    if RUBY_PLATFORM =~ /darwin/
      vb.customize ["modifyvm", :id, "--audiocontroller", "hda"]

    elsif RUBY_PLATFORM =~ /mingw|mswin|bccwin|cygwin|emx/
      vb.customize ["modifyvm", :id, '--audio', 'dsound', 
                                     '--audiocontroller', 'ac97']
    end


    # EMPTY DVD-DRIVE FOR INSTALLING VBOX-GUEST-ADDITION
    vb.customize ["storageattach", :id, "--storagectl", "IDE Controller", 
                                "--port", "1", 
                                "--device", "0", 
                                "--type", "dvddrive", 
                                "--medium", "emptydrive"]
  end

  config.vm.synced_folder ".", "/vagrant"
  config.vm.provision :shell, :path => "./provision.sh", :privileged => false
end

