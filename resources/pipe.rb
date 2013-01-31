actions :create, :delete

attribute :log_file, :kind_of => String, :name_attribute => true
attribute :tag, :kind_of => String, :default => ''
attribute :severity, :kind_of => String, :default => 'info'
attribute :poll_interval, :kind_of => Integer, :default => 10

def initialize(*args)
  super
  @action = :create
end