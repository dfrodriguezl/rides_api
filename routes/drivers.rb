class RidesApi <  Sinatra::Application

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