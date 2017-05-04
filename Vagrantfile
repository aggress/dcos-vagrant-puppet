Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "boot"
  config.vm.network :private_network, ip: "192.168.33.40"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end
end
