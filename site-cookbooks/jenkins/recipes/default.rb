#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Jenkins本体のインストール
apt_repository "jenkins" do
	uri "http://pkg.jenkins-ci.org/debian binary/"
	key "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key"
	
	retries 2
	retry_delay 10
	action :add
end

package "jenkins" do
	action :install
end

service "jenkins" do
	action [:enable, :start]
end

