require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rails-caddy"
    gem.summary = %Q{TODO}
    gem.email = "jtrupiano@gmail.com"
    gem.homepage = "http://github.com/jtrupiano/rails-caddy"
    gem.authors = ["John Trupiano"]
    gem.add_dependency "timecop", "~> 0.2.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  config = YAML.load(File.read('VERSION.yml'))
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rails-caddy #{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Rubyforge documentation task
begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do
    
    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]
    
    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/rails-caddy/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end


require 'test/rails_modifier.rb'
def rails_versions
  %w(2.3.2 2.2.2 2.1.2)
end
namespace :test do
  desc "Test all supported versions of rails. This takes a while."
  task :rails_compatibility do
    puts `mkdir -p test/rails`
    puts `rm -rf test/rails/*`
    begin
      Dir.chdir "test/rails" do
        rails_versions.each do |version|
          `rm -rf #{version}`
          puts "Creating fresh version of rails app v#{version}"
          `rails _#{version}_ #{version}`
          puts "Done."
          Dir.chdir version do
            puts "Establishing necessary code revisions"
            RailsModifier.modify!(version)
            puts "Testing Rails #{version}"
            puts `ruby test/functional/frogs_controller_test.rb`
            puts `ruby test/functional/rails_caddy_controller_test.rb`
          end
        end
      end
    ensure
     #`rm -rf test/rails`
    end
  end
end
