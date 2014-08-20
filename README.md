# EncryptedDataBagItem with chef-solo sample

A Sample project that shows how to use EncryptedDataBagItem with chef-solo or knife-solo.

### problem

* Need to review a repository for Infrastructure as Code
* The repository should be opend to people without access to secrets for review 
* But core memebers want to share secrets by the repository

By 'secrets', I mean tokens like passwords or api-keys.

### solution

* Share only one 'sceret key file' with people who needs secrets
* Put secrets as EncryptedDataBagItem of chef
* Depoly files with secrets, with chef-solo or kinfe-solo
* People that have access to repository but don't have 'secret key file' can see what tokens are there in DataBag, but cann't see exact password or api-key

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

People who want to generate a new token must have whole "secret/*" direcotry. But people who need to use the tokens with chef-solo must have the secret file only.

## Encrypt not only token but whole file

If you put a file without '*.json' ext to 'secret/sources' directory, the whole content of the file will be encrypted and put to the data bag.

It can be decrypted by a recipe like this.

```ruby
sample = Chef::EncryptedDataBagItem.load("files", "sample.txt")
file "#{RESULT_ROOT}/sample.txt" do
  content sample["content"]
end

```

## ref

* [Chef Solo encrypted data bags/ed.victavision.co.uk](http://ed.victavision.co.uk/blog/post/4-8-2012-chef-solo-encrypted-data-bags)









