#
# Cookbook Name:: capistrano
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "ruby2.0" do
	action :install
end

gem_package "capistrano" do
	action :install
end
