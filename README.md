Description [![Build Status](https://travis-ci.org/hipsnip/logentries-rsyslog.png)](https://travis-ci.org/hipsnip/logentries-rsyslog)
===========
A simple cookbook for setting up a server to stream logs into Logentries, using Rsyslogd.
The default cookbook sets up Rsyslogd to send all syslog entries to Logentries via a Token-based input.
The cookbook also provides the "logentries_pipe" resource, which sets up Rsyslogd to
tail and stream the given log file into Logentries (see below for usage).

> NOTE: While it is functional, this cookbook is no longer being actively worked on.
If you're interested in taking over, please do get in touch!


Requirements
============
Built to run on systems with Rsyslog installed. Tested on Ubuntu 11.10 and 12.04


Attributes
==========
* logentries/syslog_selector
    * The syslog tags and types to stream into Logentries (defaults to "*.*")
* logentries/resume_retry_count
    * The number of times to retry the sending of failed messages (defaults to unlimited)
* logentries/queue_disk_space
	* The maximum disk space allowed for queues (default to 100M)
* logentries/enable_tls
	* Whether to encrypt all log traffic going into Logentries (default to True). Automatically switches from UDP to TCP as well.


Usage
=====
First, make sure you set the [:logentries][:port] attribute in your Role/Environment, to the destination port created in Logentries.
Then include the "logentries::default" recipe in you run list to start streaming all syslog entries to Logentries.

### Tailing log files
For files which aren't covered by syslog, you can use the "logentries_pipe" resource
to set up Rsyslog to tail them for you:

    logentries_pipe "/var/log/httpd/access.log" do
        tag "apache-access-log"
        severity "info"
        poll_interval 3
        action :create
    end

This would start tailing the Apache access log at the given path, checking for changes every 3 seconds, and tagging entries as "apache-access-log.info".
All parameters except the target log file are optional. The default values are:

* **tag**: the basename of the log file
* **severity**: "info"
* **poll_interval**: 10