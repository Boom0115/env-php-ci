#
# Cookbook Name:: phpenv
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 配列で列挙しているパッケージをインストールする
%w{curl php5 php5-cli php5-fpm php5-mysql php-pear php5-curl php5-xsl php5-mcrypt mysql-server-5.5 nginx git vim}.each do |p|
	package p do
		action :install
	end
end

# nginx のログディレクトリのパーミッションを空ける
%w{
	/var/log/nginx
	/var/log/nginx/access.log
	/var/log/nginx/error.log
}.each do |file|
	execute "#{file} permission" do
		not_if "test `stat -c '%a' #{file}` -eq '644'"
		command "chmod 0755 #{file}"
		user "root"
		group "root"
		action :run
	end
end

# mcryptモジュールを有効にする
execute "php5enmod mcrypt" do
	action :run
end

# 今回はApacheを使用しないため、パッケージがインストール済みの場合はサービスを停止して無効化する
service "apache2" do
	action [:disable, :stop]
	only_if "dpkg -l | grep apache2"
end

# nginx用の設定ファイルをテンプレートから作成する
template "/etc/nginx/sites-available/test" do
	source "test.erb"
	owner "root"
	group "root"
	mode 0644
	action :create
	only_if { node['nginx']['test']['available'] == true }
end

# シンボリックリンクを貼って設定ファイルを有効化する
link "/etc/nginx/sites-enabled/test" do
	to "/etc/nginx/site-available/test"
	only_if { node['nginx']['test']['available'] == true }
end

# デフォルトのサイト設定を上書きする
template "/etc/nginx/sites-available/default" do
	source "default.erb"
	owner "root"
	group "root"
	mode 0644
	action :create
end

# Nginxのドキュメントルートを作成する
directory node['nginx']['docroot']['path'] do
	owner node['nginx']['docroot']['owner']
	group node['nginx']['docroot']['group']
	mode 0755
	action :create
	recursive true
	only_if { not File.exists?(node['nginx']['docroot']['path']) and
	                           node['nginx']['docroot']['force_create']}
end

# ダミーのPHPスクリプトを作成する
template "#{node['nginx']['docroot']['path']}/index.php" do
	source "index.php.erb"
	owner node['nginx']['docroot']['owner']
	group node['nginx']['docroot']['group']
	mode 0644
	action :create
	only_if { not File.exists?("#{node['nginx']['docroot']['path']}/index.php") and
	                              node['nginx']['docroot']['force_create']}
end

# Nginxのサービスを有効化して起動する
service "nginx" do
	action [:enable, :restart]
end

# MySQLのサービスを有効化して起動する
service "mysql" do
	action [:enable, :restart]
	supports :status => true, :start => true, :stop => true, :restart => true
	not_if do File.exists?("/var/run/mysqld/mysqld.pid") end
end

# MySQLのrootアカウントのパスワードを設定する
execute "set_mysql_root_password" do
	command "/usr/bin/mysqladmin -u root password \"#{node['mysql']['root_password']}\""
	action :run
	only_if "/usr/bin/mysql -u root -e 'show databases;'"
end
