require 'rake'

desc "Run Strainer to create sandbox and test cookbook"
task :test do
  puts "=== Running Strainer... ==="
  sh "bundle exec strainer test -p .. logentries-rsyslog"
end

desc "Run Strainer with fail-fast - for development"
task :dev_test do
  puts "=== Running Strainer... ==="
  sh "bundle exec strainer test --fail-fast -p .. logentries-rsyslog"
end

task :default => 'test'