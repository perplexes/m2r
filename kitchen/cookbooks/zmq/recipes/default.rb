#
# Cookbook Name:: zmq
# Recipe:: default
#
# Copyright 2012, Arkency
#
# All rights reserved - Do Not Redistribute
#

package 'uuid-dev'

zmq     = node['zmq'] || {}
zmq_v   = zmq['version'] || '2.2.0'
#zmq_v   = zmq['version'] || '3.2.1-rc2'
name    = "zeromq-#{zmq_v}.tar.gz"
unpack  = 'zeromq-' + zmq_v.split("-").first

cache_dir             = Chef::Config[:file_cache_path]
download_destination  = File.join(cache_dir, name)
unpack_destination    = File.join(cache_dir, unpack)

remote_file download_destination do
  source "http://download.zeromq.org/#{name}"
  mode "0644"
  action :create_if_missing
end

execute "Extract zmq #{zmq_v} archive" do
  command "tar xvzf #{download_destination} -C #{cache_dir}"
  creates unpack_destination
end

execute "Install zmq #{zmq_v} version" do
  command "cd #{unpack_destination} && ./configure && make && sudo make install && sudo ldconfig"
  not_if { `ldconfig -p | grep libzmq | wc -l`.to_i > 0}
end
