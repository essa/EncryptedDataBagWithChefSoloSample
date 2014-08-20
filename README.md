# EncryptedDataBagItem with chef-solo sample

A Sample project that shows how to use EncryptedDataBagItem with chef-solo or knife-solo.

### Problem

It's easy to exclude passwords from application source repository.

But if you want to do 'Infrastructure as Code', infra code repository tend to have passwords or api-keys to use it directory with provisioning tool like chef-solo.

* Need to review a repository for Infrastructure as Code
* The repository should be opend for review to people who don't have access to secrets 
* But core memebers want to share secrets by the repository

By 'secrets', I mean tokens like passwords or api-keys.

### Solution

* Share only one 'sceret key file' with people who needs secrets
* Put secrets as an 'EncryptedDataBagItem' of chef
* Deploy files with secrets, with chef-solo or kinfe-solo
* People that have access to repository but don't have 'secret key file' can see what tokens are there in DataBag and how the are used in templates of config files, but cann't see exact password or api-key

You can do this easily with chef-server, but I have found few sample to use EncryptedDataBagItem with chef-solo or kinfe-solo in a smaller project.

## How to use it.

### 1. Generate key file and share it

```
$ rake databags:create_key
```

A new secret key file will be generated at "secret/secret_key". Share it with friends in a safe way, ideally off line.

### 2. Put secret tokens in secret/sources/*/*.json

All files should have "id" attributes same as file name.

passwords/mysql.json
```json
{
    "id": "mysql", 
    "root": "mysqlrootpassword", 
    "monitoring": "mysqlmonitorpassword"
}
```

Never add 'sources/*' files to repository.

### 3. Run encrypt command

```
$ rake databags:encrypt
```

This tasks is the core of this sample project.

It will encrypt json files and put them to 'chef-repo/data_bags'. They can be add to repository.


### 4. Decrypt with chef-solo

People who are shared secret file can decrypt tokens by running chef-solo.

"chef-repo/site-cookbooks/data_bag_test/" is a sample recipe for decrypting with chef-solo.

```ruby
s3_creds = Chef::EncryptedDataBagItem.load("api_keys", "s3")
Chef::Log.info("S3 access_key is: ‘#{s3_creds["access_key"]}’")
Chef::Log.info("S3 secret_key is: ‘#{s3_creds["secret_key"]}’")
```

```erb
<% mysql_creds = Chef::EncryptedDataBagItem.load("passwords", "mysql") %>
production:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: sample_mysql_production
  pool: 5
  username: root
  password: <%= mysql_creds["root"] %>
  host: localhost
```

People who want to put a new token must have whole "secret/*" direcotry. But people who only need to use the tokens with chef-solo need to have the secret file only.

If most of members put new tokens, this method is useless because whole "secret/*" direcotry need to be shared in realtime. 

But in many cases, one or a few member buy subscriptions of services and set api-keys. The rest only use the key or password.

In these cases, only one secret file should be shared at the begining of the project. And any tokens can be added after that.

## Encrypt not only token but whole file

If you put a file without '*.json' ext to 'secret/sources' directory, the whole content of the file will be encrypted and put to the data bag.

It can be decrypted by a recipe like this.

```ruby
sample = Chef::EncryptedDataBagItem.load("files", "sample.txt")
file "#{RESULT_ROOT}/sample.txt" do
  content sample["content"]
end

```

## How strong is the encryption

I don't know.

It depends on the implementation of Chef::EncryptedDataBagItem.

Please use it by your own risk.

## Ref

* [Chef Solo encrypted data bags/ed.victavision.co.uk](http://ed.victavision.co.uk/blog/post/4-8-2012-chef-solo-encrypted-data-bags)









