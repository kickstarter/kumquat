class Knit2HTML

  KNITR_OPTIONS       = %w(use_xhtml smartypants mathjax highlight_code base64_images)
  KNITR_LIBRARIES     = %w(knitr DBI RPostgres)

  def initialize(file)
    @file = file
    Kumquat.logger = Logger.new(Rails.root.join('log', "kumquat.log"))
    Kumquat.logger.debug "[Kumquat] file: #{@file}"
  end

  def write_redshift_connection_string(tmp_dir)
    c = "redshift <- dbConnect(RPostgres::Postgres(),
      dbname = '#{Kumquat.redshift_database}',
      host = '#{Kumquat.redshift_host}',
      port = #{Kumquat.redshift_port},
      user = '#{Kumquat.redshift_user}',
      password = '#{Kumquat.redshift_password}'
    )"
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
        # redshift_connection(tmp_dir),
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
