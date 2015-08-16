require "kumquat/engine"
require 'kumquat/knit2html'
require 'kumquat/rmd_template_handler'
require 'kumquat/kumquat_report_interceptor'

module Kumquat
  mattr_accessor :redshift_host, :redshift_database, :redshift_user, :redshift_port, :redshift_password, :logger

  def self.redshift_config(config)
    @@redshift_host       = config['host']
    @@redshift_database   = config['dbname']
    @@redshift_user       = config['user']
    @@redshift_port       = config['port']
    @@redshift_password   = config['password']
  end
end
