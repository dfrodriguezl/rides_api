class RidesApi <  Sinatra::Application

  # Finish ride
  #
  # @param [id_ride] id of finished ride
  # @param [latitude_finish] latitude of final location
  # @param [longitude_finish] longitude of final location
  # @param [email] email of user
  # @return [status] transaction status
  # @return [transaction_id] transaction id
  # @return [cost] total cost of ride
  # @return [message] message from status
  post '/finishRide' do
    content_type :json
    params do
      required(:id_ride).filled(:int)
      required(:latitude_finish).filled(:float?)
      required(:longitude_finish).filled(:float?)
      required(:email).filled(:str?)
    end

    params = JSON.parse request.body.read
    id_ride = params['id_ride']
    latitude_finish = params['latitude_finish']
    longitude_finish = params['longitude_finish']
    email = params['email']
    response = finish_ride(id_ride, latitude_finish, longitude_finish, email)
    response.to_json
  end

end