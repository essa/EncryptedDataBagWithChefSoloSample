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

s3_creds = Chef::EncryptedDataBagItem.load("api_keys", "s3")
Chef::Log.info("S3 access_key is: ‘#{s3_creds["access_key"]}’")
Chef::Log.info("S3 secret_key is: ‘#{s3_creds["secret_key"]}’")

sample = Chef::EncryptedDataBagItem.load("files", "sample.txt")
Chef::Log.info("Decrypted file content is: ‘#{sample["content"]}’")

RESULT_ROOT = "/tmp/databag_test_result"

directory RESULT_ROOT

template "#{RESULT_ROOT}/database.yml" do
end

template "#{RESULT_ROOT}/sample.sh" do
  mode 0755
end

