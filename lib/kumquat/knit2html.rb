class Knit2HTML

  KNITR_OPTIONS       = %w(use_xhtml smartypants mathjax highlight_code base64_images)
  KNITR_LIBRARIES     = %w(knitr DBI RPostgres)

  def initialize(file)
    @file = file
    Kumquat.logger = Logger.new(Rails.root.join('log', "kumquat.log"))
    Kumquat.logger.debug "[Kumquat] file: #{@file}"
  end

  def knit
    f = ''
    Dir.mktmpdir('kumquat_') do |tmp_dir|

      r_commands = [
        "setwd('#{tmp_dir}');",
        "#{r_libraries}",
        database_connection(tmp_dir),
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

  protected

  def write_database_connection_string(tmp_dir)
    c = "database <- dbConnect(#{Kumquat.database_connector},
      dbname = '#{Kumquat.database_database}',
      host = '#{Kumquat.database_host}',
      port = #{Kumquat.database_port},
      user = '#{Kumquat.database_user}',
      password = '#{Kumquat.database_password}'
    )"
    File.open("#{tmp_dir}/database_credentials.r", "w") {|f| f.puts c}
  end

  def database_connection(tmp_dir)
    return if Kumquat.database_connector.nil?
    write_database_connection_string(tmp_dir)
    "source('database_credentials.r');"
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
end
