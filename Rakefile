require 'rake'
require 'fileutils'
require 'rspec/core/rake_task'

test_dir = "cookbook_test"
cookbook_name = "logentries-rsyslog"
cookbook_dir = File.join(test_dir, cookbook_name)
directory test_dir => [:clear_sandbox]
directory cookbook_dir => [test_dir]


desc "Run foodcritic linter on this cookbook"
task :foodcritic do
  sh "foodcritic --epic-fail any #{cookbook_dir}"
end


desc "Run knife test on this cookbook"
task :knife_test do
  sh "knife cookbook test -o #{test_dir} #{cookbook_name}"
end


desc "Removes sandbox folder"
task :clear_sandbox do
  puts "=== Clearing sandbox... ==="
  FileUtils.rm_rf(test_dir) if File.exist? test_dir
end


desc "Make a copy of the cookbooks under cookbook_test"
task :create_sandbox => [cookbook_dir] do
  puts "=== Creating sandbox... ==="

  # This cookbook
  FileList['*'].exclude('.*', 'bin', 'vendor', 'Berksfile*', 'Gemfile*', 'dev_setup', 'Rakefile', 'spec', test_dir).each do |src|
    FileUtils.cp_r(src, cookbook_dir)
  end

  # Berkshelf dependencies
  FileList['vendor/cookbooks/*'].each do |src|
    FileUtils.cp_r(src, test_dir)
  end
end


desc "Run spec suite"
RSpec::Core::RakeTask.new(:spec, :create_sandbox) do |t|
  t.pattern = %w(spec)
  rspec_opts = ['--color', '--fail-fast', '--format documentation']
  t.rspec_opts = rspec_opts
end


desc "Run foodcritic first and then chefspec"
task :test => [:create_sandbox] do
  puts "=== Running Tests... ==="
  Rake::Task[:knife_test].invoke
  Rake::Task[:foodcritic].invoke
  Rake::Task[:spec].invoke
end

task :default => 'test'