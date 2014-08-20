#
# Cookbook Name:: data_bag_test
# Recipe:: default
#

Chef::Log.info(Dir.pwd)
mysql_creds = Chef::EncryptedDataBagItem.load("passwords", "mysql")
root_pw = mysql_creds["root"]
monitoring_pw = mysql_creds["monitoring"]
Chef::Log.info("The root mysql password is: ‘#{root_pw}’")
Chef::Log.info("The mysql monitoring password is: ‘#{monitoring_pw}’")
