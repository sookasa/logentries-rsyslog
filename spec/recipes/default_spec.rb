require 'spec_helper'

describe "logentries-rsyslog::default" do
  context "with the default attributes" do
    let(:chef_run) do
      chef_run = ChefSpec::ChefRunner.new(cookbook_path: COOKBOOK_PATH, platform:'ubuntu', version:'12.04')
      chef_run.node.set['logentries']['token'] = "1a2b3c"
      chef_run.converge 'logentries-rsyslog::default'
    end

    it { expect(chef_run).to install_package("rsyslog-gnutls") }
  end
end