Sequel.migration do
  change do
    create_table(:drivers) do
      primary_key :id_driver
      String :name, :null => false
      String :dni, :null => false
      Float :current_longitude
      Float :current_latitude
    end

    create_table(:riders) do
      primary_key :id_rider
      String :email, :null => false
      Float :current_longitude
      Float :current_latitude
      String :tokenized_card
      String :payment_source
    end

    create_table(:rides) do
      primary_key :id_ride
      DateTime :start_time
      DateTime :finish_time
      Float :cost
      Float :distance
      Float :start_longitude
      Float :start_latitude
      Float :finish_longitude
      Float :finish_latitude
      Integer :id_driver
      Integer :id_rider
    end

    from(:drivers).insert(id_driver: 1 ,name: 'Conductor 1', dni: '1018469957', current_longitude: -74.066956, current_latitude: 4.621179)
    from(:drivers).insert(id_driver: 2 ,name: 'Conductor 2', dni: '1018469957', current_longitude: -74.081161, current_latitude: 4.628451)
    from(:drivers).insert(id_driver: 3 ,name: 'Conductor 3', dni: '1018469957', current_longitude: -74.102215, current_latitude: 4.668083)
    from(:drivers).insert(id_driver: 4 ,name: 'Conductor 4', dni: '1018469957', current_longitude: -74.045860, current_latitude: 4.761818)
    from(:drivers).insert(id_driver: 5 ,name: 'Conductor 5', dni: '1018469957', current_longitude: -74.056260, current_latitude: 4.604848)

  end
end