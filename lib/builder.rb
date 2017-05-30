# -*- mode: ruby -*-
# vi: set expandtab ft=ruby ts=2 sw=2 :

require 'yaml'

class Builder
  attr_accessor :config, :servers,
                :environments, :whitelist

  include Enumerable

  def initialize(config, environments)
    @config = config
    @servers = if File.exists?(@config) then YAML.load_file(@config) else [] end
    @environments = environments
    @whitelist = if File.exists?(@environments) then YAML.load_file(@environments) else {} end
  end

  def each(&block)
    @servers.each(&block)
  end

  def allowed?(server)
    if @whitelist['allow']
      @whitelist['allow'].each do |environment|
        if server.casecmp(environment) == 0
          return true
        end
      end
    end

    return false
  end

  def export(group)
    servers = @servers.select { |server| server['group'].casecmp(group) == 0 }
    names = servers.collect { |server| server['name'] }
    if !names.empty?
      yaml = { 'allow' => names }.to_yaml
      File.open(@environments, 'w') { |file| file.write(yaml) }
      return true
    end

    return false
  end
end