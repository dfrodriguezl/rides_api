# Method to create a payment source from tokenized card and email
def create_payment_source(tokenized_card, email_user)
  base_uri = "https://sandbox.wompi.co/v1"
  private_key = "prv_test_j8zqQEDE08IMlF8JDpjF6LvjFx5o8eEL"
  url_transaction = base_uri + "/payment_sources"
  acceptance_token = get_acceptance_token()
  options = {
      "customer_email" => email_user,
      "type" => "CARD",
      "token" => tokenized_card,
      "acceptance_token" => acceptance_token
  }

  response = HTTParty.post(url_transaction, :headers => {"Authorization" => "Bearer " + private_key}, :body => options.to_json)
  
  result = {
    "status" => "DENIED",
    "payment_source_id" => 0,
    "message" => ""
  }

  if response["error"]
    result["status"] = response["error"]["type"]
    result["message"] = response["error"]["messages"]
  else 
    result["status"] = response["data"]["status"]
    result["payment_source_id"] = response["data"]["id"]
    result["message"] = "Payment source created"
    DB[:riders].insert(email: email_user, tokenized_card: tokenized_card, payment_source: response["data"]["id"])
  end

  return result
end

# Method to get acceptance token of commerce
def get_acceptance_token
  base_uri = "https://sandbox.wompi.co/v1"
  public_key = "pub_test_UOh6Vc6Wy3lOYLnJgf488hoIRc1M10yU"
  url_transaction = base_uri + "/merchants/" + public_key
  response = HTTParty.get(url_transaction)
  acceptance_token = response["data"]["presigned_acceptance"]["acceptance_token"]
  return acceptance_token
end

# Method to request a ride from email and current location of user
def request_ride(latitude, longitude, email)
  id_driver = assign_driver(latitude, longitude)
  id_rider = Rider.select(:id_rider).where(email: email).first[:id_rider]
  id_ride = startRide(id_driver, id_rider, longitude, latitude)
  driver = Driver.select(:name).where(id_driver: id_driver).first[:name]
  result = {
    "message" => "Ride started",
    "id_ride" => id_ride,
    "driver" => driver
  }

  return result
end

# Assign nearest driver to user location
def assign_driver(latitude, longitude)
  nearest_driver = 0
  distance = 100000000000000000000
  Driver.each do |x| 
    if distance([latitude, longitude], [x.current_latitude, x.current_longitude]) < distance
      distance = distance([latitude, longitude], [x.current_latitude, x.current_longitude])
      nearest_driver = x.id_driver
    end
  end

  return nearest_driver
end

# Start a ride: Insert row in ride table
def startRide(id_driver, id_rider, start_longitude, start_latitude)
  id_ride = Ride.insert(start_time: DateTime.now, start_longitude: start_longitude, start_latitude: start_latitude, id_driver: id_driver, id_rider: id_rider)
  return id_ride
end



