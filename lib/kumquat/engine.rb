module Kumquat

  mattr_accessor :redshift_host, :redshift_database, :redshift_user, :redshift_port, :redshift_password

  def self.redshift_config=(config)
    @@redshift_host       = config['host']
    @@redshift_database   = config['dbname']
    @@redshift_user       = config['user']
    @@redshift_port       = config['port']
    @@redshift_password   = config['password']
  end

  def self.logger
    @@logger ||= Logger.new(Rails.root.join("log", "kumquat.log"))
  end

  class Engine < ::Rails::Engine
    isolate_namespace Kumquat
    REPORTS_PATH        = "app/reports"

  end

  class Knit2HTML

    KNITR_OPTIONS       = %w(use_xhtml smartypants mathjax highlight_code base64_images)
    KNITR_LIBRARIES     = %w(knitr redshift)

    def initialize(file)
      @file = file
      Kumquat.logger.debug "[Kumquat] file: #{@file}"
    end

    def write_redshift_connection_string(tmp_dir)
      postgres_uri = "jdbc:postgresql://#{Kumquat.redshift_host}:#{Kumquat.redshift_port}/#{Kumquat.redshift_database}"
      c = "redshift <- redshift.connect('#{postgres_uri}', '#{Kumquat.redshift_user}', '#{Kumquat.redshift_password}')"
      File.open("#{tmp_dir}/redshift_credentials.r", "w") {|f| f.puts c}
    end

    def redshift_connection(tmp_dir)
      write_redshift_connection_string(tmp_dir)
      "source('redshift_credentials.r');"
    end

    def r_libraries
      KNITR_LIBRARIES.map{|l| "library(#{l});"}*' '
    end

    def knitr_options
      options = KNITR_OPTIONS.map{|o| "'#{o}'"}*', '
      "c(#{options})"
    end

    def shell_command(r)
      %Q(Rscript -e "#{r}" 2>&1)
    end

    def knit
      f = ''
      Dir.mktmpdir('kumquat_') do |tmp_dir|

        r_commands = [
          "setwd('#{tmp_dir}');",
          "#{r_libraries}",
          redshift_connection(tmp_dir),
          "knit2html('#{@file}', options=#{knitr_options});"
        ].join(' ')

        Kumquat.logger.debug "[Kumquat] knitr Rscript: #{shell_command(r_commands)}"

        output = `#{shell_command(r_commands)}`

        Kumquat.logger.debug "[Kumquat] knitr output: #{output}"

        output_file = output[/output file: (.+)/,1].gsub(/\.md/,'.html')
        f = File.read(File.join("#{tmp_dir}/#{output_file}"))
      end
      return f
    end

  end
end
