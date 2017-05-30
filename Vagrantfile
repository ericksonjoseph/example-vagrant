# -*- mode: ruby -*-
# vi: set expandtab ft=ruby ts=2 sw=2 :

require File.join(File.dirname(__FILE__), '/lib/builder')
builder = Builder.new('./config.yaml', './.boxesrc')

Vagrant.require_version '>= 1.6.0'
Vagrant.configure(2) do |vagrant|
  builder.each do |server|
    if builder.allowed? server['name']
      vagrant.vm.define server['name'] do |config|
        config.vm.box = server['box']
        if server['version']
          config.vm.box_version = server['version']
        end
        config.vm.hostname = server['hostname']
        config.vm.network :private_network, ip: server['ip']
        if server['ports']
          server['ports'].each do |port|
            config.vm.network "forwarded_port", guest: port['guest'], host: port['host']
          end
        end

        config.vm.synced_folder '.', '/vagrant', disabled: true
        if server['mount']
          server['mount'].each do |mount|
            config.vm.synced_folder mount['source'], mount['destination'], id: mount['id'], owner: 'vagrant', group: 'vagrant'
          end
        end

        config.vm.provider :virtualbox do |vb|
          vb.customize ['modifyvm', :id, '--name', "client_#{server['hostname']}"]
          vb.customize ['modifyvm', :id, '--cpus', server['cpus']]
          vb.customize ['modifyvm', :id, '--memory', server['memory']]
          vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
          if server['mount']
            server['mount'].each do |mount|
              vb.customize ['setextradata', :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/#{mount['id']}", '1']
            end
          end
        end

        if server['provision']
          config.vm.provision :shell, path: server['provision']
        end

        config.ssh.forward_agent = true
        config.ssh.insert_key = false
      end
    end
  end
end
