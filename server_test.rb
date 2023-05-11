require_relative 'server'
require 'test/unit'
require 'rack/test'

class RidesApiTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_create_payment_method
    data = {
      "tokenized_card" => "tok_test_44832_6e11f5eE6ad3c287fa91CdcE8b723221",
      "email" => "dfrodriguezl94@gmail.com"
    }
    h = {'Content-Type' => 'application/json'}
    post '/createPaymentMethod', "data" => data.to_json, "headers" => h
    response = '{
      "status": "INPUT_VALIDATION_ERROR",
      "payment_source_id": 0,
      "message": {
          "token": [
              "El token ya está en uso"
          ]
      }
    }'
    assert last_response.body.to_s, response.to_s
  end

  def test_request_ride
    data = {
      "latitude" => 4.715389,
      "longitude" => -74.141558,
      "email" => "dfrodriguezl94@gmail.com"
    }
    h = {'Content-Type' => 'application/json'}
    post '/requestRide', "data" => data.to_json, "headers" => h
    response = '{
      "message": "Ride started",
    }'
    assert last_response.body.to_s, response.to_s
  end

  def test_finish_ride
    data = {
      "id_ride": 11,
      "latitude_finish": 4.646950,
      "longitude_finish": -74.096789,
      "email": "dfrodriguezl94@gmail.com"
    }
    h = {'Content-Type' => 'application/json'}
    post '/finishRide', "data" => data.to_json, "headers" => h
    response = '{
      "status": "INPUT_VALIDATION_ERROR",
      "transaction_id": 0,
      "cost": 0,
      "message": {
          "reference": [
              "La referencia ya ha sido usada"
          ]
      }
    }'
    assert last_response.body.to_s, response.to_s
  end
end