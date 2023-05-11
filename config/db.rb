require 'sequel'
require 'yaml'


config = YAML::load_file("config/database.yml")["development"]

DB = Sequel.connect(adapter: :postgres, database: config["database"], host: config["host"] , port: config["port"], user:config["user"], password: config["password"])

Sequel::Model.plugin :json_serializer






