Vagrant.configure("2") do |config|
  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = "centos/7"
    jenkins.vm.hostname = "jenkins.vm"
    jenkins.vm.network "private_network", ip: "192.168.56.10"
    jenkins.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
    end
  end

  config.vm.define "gogs" do |gogs|
    gogs.vm.box = "centos/7"
    gogs.vm.hostname = "gogs.vm"
    gogs.vm.network "private_network", ip: "192.168.56.11"
  end

  config.vm.define "deploy" do |deploy|
    deploy.vm.box = "centos/7"
    deploy.vm.hostname = "deploy.vm"
    deploy.vm.network "private_network", ip: "192.168.56.12"
  end
end
