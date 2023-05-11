require 'sinatra'
require_relative 'config/db'
require 'json'
require 'httparty'
require 'dry/validation'

require_relative 'models/init'
require_relative 'routes/init'
require_relative 'helpers/init'

class RidesApi < Sinatra::Application
  run! if app_file == $0
end

