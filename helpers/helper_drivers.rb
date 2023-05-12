# Finish ride
def finish_ride(id_ride, latitude_finish, longitude_finish, email)
  update_ride_time_location(id_ride, latitude_finish, longitude_finish)
  ride = get_ride_attributes(id_ride)
  interval_min = calculate_time_interval(ride[:start_time], ride[:finish_time])
  distance = distance([ride[:start_latitude], ride[:start_longitude]], [ride[:finish_latitude], ride[:finish_longitude]])/1000
  total_amount = calculate_amount_ride(interval_min, distance)
  update_ride_cost_distance(id_ride, total_amount, distance)
  rider = get_rider_attributes(ride[:id_rider])
  return create_transaction(total_amount*100, email, rider[:payment_source], id_ride)
end

# Calculate total amount to be paid
def calculate_amount_ride(time_interval, distance)
  amount_distance = 1000*distance
  amount_time = 200*time_interval
  base_fee = 3500
  return amount_distance + amount_time + base_fee
end

# Create transaction and charging total amount Wompi API
def create_transaction(amount_cents, email, payment_source_id, id_ride)
  base_uri = "https://sandbox.wompi.co/v1"
  private_key = "prv_test_j8zqQEDE08IMlF8JDpjF6LvjFx5o8eEL"
  url_transaction = base_uri + "/transactions"

  body = {
    "amount_in_cents" => amount_cents.to_i,
    "currency" => "COP",
    "customer_email" => email,
    "payment_method" => {
      "installments" => 1
    },
    "reference": id_ride.chr,
    "payment_source_id": payment_source_id
  }

  response = HTTParty.post(url_transaction, :headers => {"Authorization" => "Bearer " + private_key}, :body => body.to_json)

  result = {
    "status" => "DENIED",
    "transaction_id" => 0,
    "cost" => 0,
    "message" => ""
  }

  if response["error"]
    result["status"] = response["error"]["type"]
    result["message"] = response["error"]["messages"]
  else 
    result["status"] = response["data"]["status"]
    result["transaction_id"] = response["data"]["id"]
    result["cost"] = amount_cents/100
    result["message"] = "Transaction created"
  end

  return result
end

# Update table rides with finish time and final location
def update_ride_time_location(id_ride, latitude_finish, longitude_finish)
  finish_time = DateTime.now
  Ride.where(id_ride: id_ride).update(finish_time: finish_time, finish_latitude: latitude_finish, finish_longitude: longitude_finish)
end

# Get attribute of ride finished
def get_ride_attributes(id_ride)
  ride = Ride.select(:start_time, :finish_time, :start_latitude, :start_longitude, :finish_latitude, :finish_longitude, :id_rider).where(id_ride: id_ride).first
  return ride
end

# Calculate time interval in minutes
def calculate_time_interval(start_time, finish_time)
  interval_min = (finish_time - start_time)/60
  return interval_min
end

# Update table rides with cost and distance
def update_ride_cost_distance(id_ride, cost, distance)
  Ride.where(id_ride: id_ride).update(cost: cost, distance: distance)
end

# Get attribute of rider
def get_rider_attributes(id_rider)
  rider = Rider.select(:payment_source).where(id_rider: id_rider).first
  return rider
end