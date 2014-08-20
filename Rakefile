require 'rake'
require 'rubygems'
require 'chef/encrypted_data_bag_item'
 
SECRET = "secret/secret_key"
DATA_BAG_ROOT = "chef-repo/data_bags"

def create_encrypted_data_bags
  secret = Chef::EncryptedDataBagItem.load_secret(SECRET)
  data = {"id" => "mysql", "root" => "mysqlrootpassword", "monitoring" => "mysqlmonitorpassword"}
  encrypted_data = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data, secret)
 
  FileUtils.mkpath("#{DATA_BAG_ROOT}")
  File.open("#{DATA_BAG_ROOT}/mysql.json", 'w') do |f|
    f.print encrypted_data.to_json
  end
end

namespace :databags do
  desc "create secret key"
  task :create_key do
    if File.exist?(SECRET)
      STDERR.puts "ERROR: secret file #{SECRET} exists!"
      exit 1
    end
    sh "openssl rand -base64 512 > #{SECRET}"
    STDERR.puts "secret file #{SECRET} created"
  end

  desc "create encrypt data bag"
  task :encrypt do
    create_encrypted_data_bags
  end

  desc "run sample recipe with chef-solo"
  task :chefsolo do
    sh "cd chef-repo && chef-solo -c solo.rb -j nodes/testnode.json"
  end
end
