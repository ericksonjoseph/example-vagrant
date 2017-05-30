# Do *not* load any libs here that are *not* part of Ruby’s standard-lib. Ever.

desc 'Install all dependencies'
task :bootstrap do
  if system('which bundle')
    sh 'bundle install'
  else
    $stderr.puts "\033[0;31m[!] Please install the bundler gem manually: $ [sudo] gem install bundler\e[0m"
    exit 1
  end
end

# Whatever lib you need to load that is *not* part of Ruby’s standard-lib, this includes Bundler.

begin
  require 'rubygems'
rescue LoadError
  $stderr.puts "\033[0;33m[!] Disabling rake tasks because the environment couldn’t be loaded. Be sure to run `rake bootstrap` first.\e[0m"
end
