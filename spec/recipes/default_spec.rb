require 'spec_helper'


describe "logentries-rsyslog::default" do
  context 'with the default attributes' do
    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(CHEF_RUN_OPTIONS) do |node|
        node.set['logentries']['token'] = "1a2b3c"
      end
      @chef_run.converge 'logentries-rsyslog::default'
    end

    it { @chef_run.should install_package("rsyslog-gnutls") }
    it { @chef_run.should create_cookbook_file('/etc/syslog.logentries.crt') }
    it { @chef_run.should create_file("/etc/rsyslog.d/10-logentries.conf") }

    context "/etc/rsyslog.d/10-logentries.conf file" do
      it 'enables TLS' do
        @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$DefaultNetstreamDriverCAFile /etc/syslog.logentries.crt")
        @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$ActionSendStreamDriver gtls")
        @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$ActionSendStreamDriverMode 1")
        @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$ActionSendStreamDriverAuthMode x509/name")
      end

      it 'should set a new template with the token "1a2b3c"' do
        @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", '$template LogentriesFormat,"1a2b3c %HOSTNAME% %syslogtag%%msg%\n"')
      end

      it 'should set $ActionResumeRetryCount to "-1"' do
        @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$ActionResumeRetryCount -1")
      end

      it 'should set $ActionQueueMaxDiskSpace to "100M"' do
        @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$ActionQueueMaxDiskSpace 100M")
      end

      it 'should set the forwarding to "*.*     @@api.logentries.com:20000;LogentriesFormat"' do
        @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "*.*     @@api.logentries.com:20000;LogentriesFormat")
      end
    end

    context "/etc/rsyslog.d/10-logentries.conf template" do
      it { @chef_run.template("/etc/rsyslog.d/10-logentries.conf").should notify("service[rsyslog]", "restart") }
    end
  end


  context 'with TLS turned off' do
    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(CHEF_RUN_OPTIONS) do |node|
        node.set['logentries']['token'] = "1a2b3c"
        node.set['logentries']['enable_tls'] = false
      end
      @chef_run.converge 'logentries-rsyslog::default'
    end

    it { @chef_run.should_not install_package("rsyslog-gnutls") }
    it { @chef_run.should_not create_cookbook_file('/etc/syslog.logentries.crt') }
    it { @chef_run.should create_file("/etc/rsyslog.d/10-logentries.conf") }

    context "/etc/rsyslog.d/10-logentries.conf file" do
      it 'should not enable TLS' do
        @chef_run.should_not create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$ActionSendStreamDriver gtls")
        @chef_run.should_not create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$ActionSendStreamDriverMode 1")
      end
    end
  end


  context 'with resume_retry_count set to 5' do
    context 'and syslog_selector set to cron.*' do
      context 'and queue_disk_space set to 300M' do
        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new(CHEF_RUN_OPTIONS) do |node|
            node.set['logentries']['token'] = "1a2b3c"
            node.set['logentries']['resume_retry_count'] = 5
            node.set['logentries']['syslog_selector'] = "cron.*"
            node.set['logentries']['queue_disk_space'] = "300M"
          end
          @chef_run.converge 'logentries-rsyslog::default'
        end

        it { @chef_run.should create_file("/etc/rsyslog.d/10-logentries.conf") }

        context "/etc/rsyslog.d/10-logentries.conf file" do
          it 'should set a new template with the token "1a2b3c"' do
            @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", '$template LogentriesFormat,"1a2b3c %HOSTNAME% %syslogtag%%msg%\n"')
          end

          it 'should set $ActionResumeRetryCount to "5"' do
            @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$ActionResumeRetryCount 5")
          end

          it 'should set $ActionQueueMaxDiskSpace to "300M"' do
            @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "$ActionQueueMaxDiskSpace 300M")
          end

          it 'should set the forwarding to "cron.*     @@api.logentries.com:20000;LogentriesFormat"' do
            @chef_run.should create_file_with_content( "/etc/rsyslog.d/10-logentries.conf", "cron.*     @@api.logentries.com:20000;LogentriesFormat")
          end
        end
      end
    end
  end
end