require "chefspec"
COOKBOOK_PATH = "cookbook_test"

CHEF_RUN_OPTIONS = {
  :cookbook_path => COOKBOOK_PATH,
  :platform => 'ubuntu',
  :version => '12.04',
  :log_level => :fatal
}