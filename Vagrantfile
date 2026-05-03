# -*- mode: ruby -*-
# vi: set ft=ruby :

require "fileutils"

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-25.04"
  config.vm.box_check_update = false

  # config.vm.synced_folder ".", "/vagrant", disabled: true

  public_key = File.expand_path("~/.ssh/id_rsa.pub")
  raise "Missing public key: #{public_key}" unless File.exist?(public_key)
  jails_dir = File.expand_path("~/.jails")
  ssh_dir = File.join(jails_dir, ".ssh")
  authorized_keys = File.join(ssh_dir, "authorized_keys")
  FileUtils.mkdir_p(jails_dir)
  FileUtils.mkdir_p(ssh_dir)
  File.write(authorized_keys, File.read(public_key).strip + "\n")
  File.chmod(0700, ssh_dir)
  File.chmod(0600, authorized_keys)
  config.ssh.keys_only = false  # use ssh-agent stored keys in addition to vagrant-provided keys
  config.vm.synced_folder jails_dir, "/home/vagrant",
    owner: "vagrant",
    group: "vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  config.vm.provision "skel",
    type: "shell",
    privileged: false,
    inline: <<-SHELL
      set -e -x -o pipefail
      rsync -rv /etc/skel/ /home/vagrant/
    SHELL

  config.vm.provision "cache",
    type: "shell",
    privileged: true,
    inline: <<-SHELL
      set -e -x -o pipefail
      mkdir -p /cache /cache/nvm /cache/npm /cache/brew
      chown -R vagrant:vagrant /cache
      chmod 700 /cache
      mkdir -p /home/vagrant/.cache
      chown vagrant:vagrant /home/vagrant/.cache
      rm -rf /home/vagrant/.nvm /home/vagrant/.npm /home/vagrant/.cache/Homebrew
      sudo -u vagrant ln -s /cache/nvm /home/vagrant/.nvm
      sudo -u vagrant ln -s /cache/npm /home/vagrant/.npm
      sudo -u vagrant ln -s /cache/brew /home/vagrant/.cache/Homebrew
    SHELL

  config.vm.provision "apt",
    type: "shell",
    privileged: true,
    inline: <<-SHELL
      apt update
      apt install -y ruby bubblewrap kitty-terminfo
    SHELL

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
