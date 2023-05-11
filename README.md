# Rides API

REST API that allows create payment methods, start a ride and finish ride charging amount of the ride in payment platform.

Developed using Ruby, Sinatra, Sequel

## Installation

1. Install dependences

```bash
gem install bundler
bundle install
```

2. Running migrations

In file config/database.yml, you must change connection parameters of your database
```bash
  host: localhost
  port: 5433
  user: postgres
  password: postgres
  database: rides_api
```
Then, in following line you must change connection string with your database parameters
```bash
sequel -m db/migrations postgres://postgres:postgres/localhost:5433/rides_api
sequel -m db/migrations postgres://{user}:{password}/{host}:{port}/{database}
```
Then run api

```bash
ruby server.rb
```

REST API is working in http://localhost:4567

## Unit Tests

run the command for run unit tests

```bash
ruby server_test.rb
```
## Database

This project uses PostgreSQL

## Contributing

Diego Fernando Rodriguez Lamus