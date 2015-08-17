require "kumquat/engine"
require 'kumquat/knit2html'
require 'kumquat/rmd_template_handler'
require 'kumquat/kumquat_report_interceptor'

module Kumquat
  mattr_accessor :database_connector, :database_host, :database_database, :database_user, :database_port, :database_password, :logger

  def self.database_config(config)
    @@database_connector  = config['database_connector']
    @@database_host       = config['host']
    @@database_database   = config['dbname']
    @@database_user       = config['user']
    @@database_port       = config['port']
    @@database_password   = config['password']
  end
end
