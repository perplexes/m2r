#
# Cookbook Name:: mongrel2
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w[uuid-dev uuid-runtime libsqlite3-dev sqlite3].each do |name|
  package name do
    action :install
  end
end

source = "https://github.com/zedshaw/mongrel2/tarball/v1.8.0"
name   = "mongrel2-v1.8.0.tar.gz"
unpack = "zedshaw-mongrel2-bc721eb"

cache_dir             = Chef::Config[:file_cache_path]
download_destination  = File.join(cache_dir, name)
unpack_destination    = File.join(cache_dir, unpack)

remote_file download_destination do
  source source
  mode "0644"
  action :create_if_missing
end

execute "Extract mongrel2 archive" do
  command "tar xvzf #{download_destination} -C #{cache_dir}"
  creates unpack_destination
end

execute "Install mongrel2" do
  command "cd #{unpack_destination} && make clean all && sudo make install"
  not_if { `which m2sh | wc -l`.to_i > 0}
end
