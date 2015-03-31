#
# Cookbook Name:: r
# Recipe:: default
#
# Copyright 2014, Kickstarter, Inc
#
# MIT License
#
include_recipe "apt"


# Things to install:
deb_arch = case node.kernel.machine
  when 'i686'
    'i386'
  else
    'amd64'
  end

apt_repository "r-base" do
  uri "http://cran.r-project.org/bin/linux/ubuntu"
  keyserver "keyserver.ubuntu.com"
  key "E084DAB9"
  components [""]
  distribution node['lsb']['codename'] + "/"
  action :add
end

package "openjdk-6-jdk"
package "r-base"

r_packages = %w(ggplot2 hwriter reshape plyr knitr RJDBC)
r_packages.each do |pkg|
  bash "r_install_#{pkg}" do
    creates "/usr/local/lib/R/site-library/#{pkg}"
    code %Q{ Rscript -e "install.packages('#{pkg}', repos='http://cran.us.r-project.org')"}
  end
end

# Special Redshift section:
cookbook_file "/usr/src/redshift-r-0.4.tar.gz"
bash "r_install_redshift_connector" do
  creates "/usr/local/lib/R/site-library/redshift"
  code %Q{ Rscript -e "install.packages('/usr/src/redshift-r-0.4.tar.gz', dependencies = T, repos = NULL, type = 'source')" }
end
