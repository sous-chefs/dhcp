#!/usr/bin/env rake

desc "Setup the sandbox" 
task :prepare_sandbox do 
  ENV['COOKBOOK_PATH'] = "#{sandbox_path}../"
  files = %w{*.md *.rb attributes definitions files libraries providers
recipes resources templates examples spec test}

  rm_rf sandbox_path
  mkdir_p sandbox_path
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox_path
  puts "\n\n"
end


desc "Runs ruby syntax checks" 
task :ruby do
  Rake::Task[:prepare_sandbox].execute
  sh "find  #{sandbox_path}/../ -name \"*.rb\" | xargs ruby -c "
end

desc "Runs template syntax checks" 
task :erubis do
  Rake::Task[:prepare_sandbox].execute
  sh "find  #{sandbox_path}/../ -name \"*.rb\" | erubis -x "
end


desc "Runs foodcritic linter"
task :foodcritic do
  Rake::Task[:prepare_sandbox].execute
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sh "foodcritic -f correctness,services,libraries,deprecated -t ~FC001 -t ~FC019 -t ~FC017 -t ~FC003 -C #{sandbox_path}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

desc "Run chefspec"
task :chefspec do
  Rake::Task[:prepare_sandbox].execute
  sh "cd #{sandbox_path}; rspec "  
end

desc "Run all tests"
task :test => [ :ruby, :erubis, :foodcritic, :chefspec ]

desc "Default task"
task :default => :test 

private
def sandbox_path
  File.join(File.dirname(__FILE__), %w(tmp cookbooks dhcp))
end
