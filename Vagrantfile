# -*- mode: ruby -*-
# vi: set ft=ruby :

require "fileutils"

def configure_home_jail(config)
  jails_dir = File.expand_path("~/.jails")
  FileUtils.mkdir_p(jails_dir)
  File.chmod(0700, jails_dir)
  folders = [
    ".config",
    ".codex",
  ]
  folders.each_with_index do |f, i|
    host_path = File.join(jails_dir,f)
    guest_path = "/home/vagrant/#{f}"
    FileUtils.mkdir_p(host_path)
    File.chmod(0700, host_path)
    FileUtils.mkdir_p(host_path)
    config.vm.synced_folder host_path, guest_path,
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=700", "fmode=600"]
  end
end

def configure_jails_mount(config, mount_name)
  mount_value = ENV[mount_name]
  return false if mount_value.nil?
  parts = mount_value.split(":", 3)
  return false unless parts.length == 2
  host_path, guest_path = parts
  return false unless host_path.start_with?("/") && guest_path.start_with?("/")
  expanded_host_path = File.expand_path(host_path)
  raise "JAILS mount source is not a directory for #{mount_name}: #{expanded_host_path}" unless Dir.exist?(expanded_host_path)
  config.vm.synced_folder expanded_host_path, guest_path,
    owner: "vagrant",
    group: "vagrant"
  true
end

def configure_jails_mounts(config)
  index = 1
  loop do
    mount_name = "JAILS_MOUNT_#{index}"
    break unless configure_jails_mount(config, mount_name)
    index += 1
  end
end

def configure_apt_provision(config)
  config.vm.provision "apt",
    type: "shell",
    privileged: true,
    inline: <<-SHELL
      apt update
      apt install -y ruby bubblewrap kitty-terminfo
    SHELL
end

def configure_brew_provision(config)
  config.vm.provision "brew",
    type: "shell",
    privileged: false,
    inline: <<-SHELL
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' | sudo tee /etc/profile.d/brew.sh
      source /etc/profile.d/brew.sh
      brew install go gh
      brew install --cask claude-code
    SHELL
end

def configure_node_provision(config)
  config.vm.provision "node",
    type: "shell",
    privileged: false,
    inline: <<-SHELL
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
      \. "$HOME/.nvm/nvm.sh"
      nvm install 24
      node -v
      npm -v
      npm i -g opencode-ai @openai/codex
      npm ls -g
    SHELL
end

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-25.04"
  config.vm.box_check_update = false

  # config.vm.synced_folder ".", "/vagrant", disabled: true

  configure_home_jail(config)
  configure_jails_mounts(config)

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  configure_apt_provision(config)
  configure_brew_provision(config)
  configure_node_provision(config)
end
