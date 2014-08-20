
log_level :info
file_cache_path           "/tmp/chef-solo"
encrypted_data_bag_secret File.join(File.expand_path(File.dirname(__FILE__)), "../secret/secret_key")
data_bag_path File.join(Dir.pwd, 'data_bags')
file_cache_path File.join(Dir.pwd, 'cache')
cookbook_path   File.join(Dir.pwd, 'site-cookbooks')
