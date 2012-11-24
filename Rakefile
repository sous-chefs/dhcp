#!/usr/bin/env rake
@sandbox = File.join(File.dirname(__FILE__), %w{tmp test cookbook})

desc "Runs foodcritic linter"
task :foodcritic do
  prep_box(@sandbox)
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sh "foodcritic -f correctness,services,libraries,deprecated -t ~FC001 -t ~FC019 -t ~FC017 -t ~FC003 -C #{File.dirname(@sandbox)}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

desc "Run chefspec"
task :chefspec do
  prep_box(@sandbox)
  sh "cd #{File.dirname(@sandbox)}; rspec -fd --color" 
end

desc "Run all tests"
task :test => [ :foodcritic, :chefspec ]

desc "Default task"
task :default => :test 

private

def prep_box(sandbox)
  files = %w{*.md *.rb attributes definitions files libraries providers
recipes resources templates examples spec test}

  rm_rf sandbox
  mkdir_p sandbox
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox
  puts "\n\n"
end
