GrURL
===

A simple URL shortening API built with [Grape](https://github.com/intridea/grape). Backed by Redis. Reads and writes are as fast as 30ms on my quad core Macbook.

## Endpoints

- **POST: '/'** Takes `url` and `key` as paramaters, with the key being optional. If the key is not provided, it will create a unique one.
- **GET '/:key'** Redirects to the long URL.
- **GET ':key/info'** Find info including click count.

## Installing

`$ bundle install`

`$ rackup`