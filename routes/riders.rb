class RidesApi <  Sinatra::Application

  # Dry::Validation.load_extensions(:predicates_as_macros)

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