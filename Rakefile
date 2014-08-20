require 'rake'
require 'rubygems'
require 'chef/encrypted_data_bag_item'
 
SECRET = "secret/secret_key"
DATA_BAG_ROOT = File::expand_path("chef-repo/data_bags")
SOURCES = "secret/sources"

def create_data_bag_items(path, json)
  File.open(path, 'w') do |f|
    f.print json
  end
end

def create_encrypted_data_bags
  secret = Chef::EncryptedDataBagItem.load_secret(SECRET)
 
  Dir.chdir(SOURCES) do
    Dir["*"].each do |dir|
      puts dir, File::join(DATA_BAG_ROOT, dir)
      FileUtils.mkdir_p(File::join(DATA_BAG_ROOT, dir))
      Dir["#{dir}/*"].each do |f|
        puts f
        if f =~ /json$/i
          json = JSON.parse File::open(f).read
          encrypted_data = Chef::EncryptedDataBagItem.encrypt_data_bag_item(json, secret)
          p json,encrypted_data
          create_data_bag_items(File::join(DATA_BAG_ROOT, f), encrypted_data.to_json)
        else
          content = File::open(f).read
          fname = File::basename(f)
          encrypted_data = Chef::EncryptedDataBagItem.encrypt_data_bag_item({ "id" => fname, "content" => content}, secret)
          p json,encrypted_data
          create_data_bag_items(File::join(DATA_BAG_ROOT, f + ".json"), encrypted_data.to_json)

        end
      end
    end
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

  desc "archive secret files"
  task :archive do
    sh "tar zcvf secret.tar.gz secret"
  end
end
