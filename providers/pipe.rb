action :create do
  log %Q(Creating logentries pipe definition file for "#{new_resource.log_file}")

  config_name = ::File.basename(new_resource.log_file, '.log')

  file_tag = (not new_resource.tag.empty?) ? new_resource.tag : config_name

  tail_file = "/etc/rsyslog.d/150-#{file_tag}.conf"

  template tail_file do
    cookbook "logentries"
    source "rsyslog-file.erb"
    mode "0644"

    variables(
      :log_file => new_resource.log_file,
      :tag => file_tag,
      :poll_interval => new_resource.poll_interval,
      :severity => new_resource.severity
    )

    notifies :restart, "service[rsyslog]", :delayed
  end

  new_resource.updated_by_last_action(true)
end


action :delete do
  config_name = File.basename(new_resource.file, '.log')
  tail_file = "/etc/rsyslog.d/150-#{config_name}.conf"

  file tail_file do
    action :delete
  end

  new_resource.updated_by_last_action(true)
end