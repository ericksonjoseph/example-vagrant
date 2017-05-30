namespace :vm do
  require File.join(File.dirname(File.dirname(__FILE__)), '/lib/builder')

  desc 'Initializes your environment'
  task :setup, :group do |t, args|
    group = args[:group] || 'default'
    builder = Builder.new('./config.yaml', './.boxesrc')
    if !builder.export(group)
      $stdout.puts "\033[0;31m[!] The selected group does not exist or is not configured properly: #{group}\e[0m"
    end
  end

  desc 'Updates your VM'
  task :update do |t, args|
    task('vm:download').invoke()
    task('vm:reset').invoke()
  end

  desc 'Resets the VM'
  task :reset do |t, args|
    task('vm:destroy').invoke()
    task('vm:start').invoke()
  end

  desc 'Downloads the latest VM'
  task :download do |t, args|
    Kernel.system('vagrant box update')
  end

  desc 'Destroys the existing VM'
  task :destroy do |t, args|
    Kernel.system('vagrant destroy -f')
  end

  desc 'Starts the VM'
  task :start do |t, args|
    Kernel.system('vagrant up')
  end

  desc 'Pauses the VM'
  task :pause do |t, args|
    Kernel.system('vagrant suspend')
  end

  desc 'Un-pauses the VM'
  task :resume do |t, args|
    Kernel.system('vagrant resume')
  end

  desc 'Stops the VM'
  task :stop do |t, args|
    Kernel.system('vagrant halt')
  end

  desc 'Restarts the VM'
  task :restart do |t, args|
    Kernel.system('vagrant reload')
  end

  desc 'Displays the VM status'
  task :status do |t, args|
    Kernel.system('vagrant status')
  end
end

task :vm => 'vm:status'