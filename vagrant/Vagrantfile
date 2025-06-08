Vagrant.configure("2") do |config|
  config.vm.box = "generic/alma9"
  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 2048
    libvirt.cpus = 1
    libvirt.storage :file, size: '20G'
  end

  config.vm.provision "shell", inline: <<-SHELL
    #Новый пользователь
    useradd -m -G wheel stm
    echo "stm:password" | chpasswd

    #Docker
    dnf install -y dnf-plugins-core
    dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    dnf install -y docker-ce docker-ce-cli containerd.io
    systemctl enable --now docker
    usermod -aG docker stm
  SHELL
end
