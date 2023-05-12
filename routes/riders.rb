class RidesApi <  Sinatra::Application

  # Create payment method
  #
  # @param [tokenized_card] token from card
  # @param [email] email from user
  # @return [status] transaction status
  # @return [payment_source_id] id new payment source created
  # @return [message] message from status
  post '/createPaymentMethod' do
    content_type :json
    params do
      required(:tokenized_card).filled(:str?)
      required(:email).filled(:str?)
    end

    params = JSON.parse request.body.read
    tokenized_card = params['tokenized_card']
    email_user = params['email']
    response = create_payment_source(tokenized_card, email_user)
    response.to_json
  end

  # Request a new ride
  #
  # @param [latitude] latitude of user's current location
  # @param [longitude] longitude of user's current location
  # @param [email] email of user
  # @return [id_ride] id of new ride
  # @return [driver] driver name 
  # @return [message] message from status
  post '/requestRide' do
    content_type :json
    params do
      required(:latitude).filled(:float?)
      required(:longitude).filled(:float?)
      required(:email).filled(:str?)
    end

    params = JSON.parse request.body.read
    latitude = params['latitude']
    longitude = params['longitude']
    email_user = params['email']
    response = request_ride(latitude, longitude, email_user)
    response.to_json
  end

end