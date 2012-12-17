#
# Cookbook Name:: gerrit
# Recipe:: mysql
#
# Copyright 2012, Steffen Gebert / TYPO3 Association
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

include_recipe "mysql::server"
include_recipe "database::mysql"

if node['gerrit']['database']['host'] == "localhost"
  mysql_host = node['mysql']['bind_address']
end

mysql_connection_info = {
  :host =>  mysql_host,
  :username => "root",
  :password => node['mysql']['server_root_password']
}

mysql_database_user node['gerrit']['database']['username'] do
  connection mysql_connection_info
  password node['gerrit']['database']['password']
  action :create
end
 
mysql_database node['gerrit']['database']['name'] do
  connection mysql_connection_info
  action :create
end

mysql_database "changing the charset of database" do
  connection mysql_connection_info
  database_name node['gerrit']['database']['name']
  action :query
  sql "ALTER DATABASE #{node['gerrit']['database']['name']} charset=latin1"
end

mysql_database_user node['gerrit']['database']['username'] do
  connection mysql_connection_info
  database_name node['gerrit']['database']['name']
  privileges [
    :all
  ]
  action :grant
end

mysql_database "flushing mysql privileges" do
  connection mysql_connection_info
  action :query
  sql "FLUSH PRIVILEGES"
end