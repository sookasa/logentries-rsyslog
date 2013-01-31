maintainer       "HipSnip Ltd."
maintainer_email "adam@hipsnip.com"
license          "Apache 2.0"
description      "Installs/Configures logentries"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "rsyslog"

attribute "logentries/syslog_selector",
  :display_name => "Syslog Selector",
  :description => "The syslog tags that should be piped into Logentries - defaults to all",
  :type => "string",
  :default => "*.*"

attribute "logentries/resume_retry_count",
  :display_name => "Retry Count",
  :description => "The number of times to retry the sending of failed messages (defaults to unlimited)",
  :default => "-1"

attribute "logentries/queue_disk_space",
  :display_name => "Queue Disk Space",
  :description => "The maximum disk space allowed for queues",
  :type => "string",
  :default => "100M"

attribute "logentries/enable_tls",
  :display_name => "Enable TLS",
  :description => "Whether to encrypt all log traffic going into Logentries. Automatically switches from UDP to TCP as well.",
  :default => "true"

attribute "logentries/certificate_src",
  :display_name => "Certificate Source",
  :description => "The URL of the certificate file on the Logentries server",
  :type => "string",
  :default => "https://logentriesapp.com/tools/syslog.logentries.crt"

attribute "logentries/certificate_checksum",
  :display_name => "Certificate Checksum",
  :description => "The checksum for the Logentries certificate file",
  :type => "string",
  :default => "cee9b8d2d503188ccecbb22b49cd3bec"