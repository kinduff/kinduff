---
title: Simple health-check for Ruby on Rails
date: 2021-10-15
description: >-
  Simple Rack middleware for healh-checks
---

I want to share with you a very simple Rack middleware I usually use to have a health-check for the Ruby on Rails applications I develop.

This simple script is not configurable and doesn't consider a couple of things - like degradation, latency, overall health, but the simplicity it has provides a good starting point in case you want to know if you're OK or KO.

```ruby
# frozen_string_literal: true

module Rack
  class HealthCheck
    def call(_env)
      [
        green? ? 200 : 503,
        { 'Content-Type' => 'text/plain' },
        [green? ? 'OK' : 'KO']
      ]
    end

    private

    def green?
      database_connected? && elasticsearch_connected? && redis_connected?
    end

    def database_connected?
      ApplicationRecord.connection.select_value('SELECT 1') == 1
    rescue StandardError
      false
    end

    def elasticsearch_connected?
      Elasticsearch::Client.new.ping
    rescue StandardError
      false
    end

    def redis_connected?
      Redis.current.ping == 'PONG'
    rescue StandardError
      false
    end
  end
end

```

To use this, you need to save it at `lib/rack/health_check.rb` and then require it in your `config.ru` file like so:

```ruby
require_relative 'lib/rack/health_check'

map '/healthz' do
  run Rack::HealthCheck.new
end
```

Then any request made to the endpoint will result in a 200 and OK if everything is fine, and 503 and KO if a service is down. For example:

```shell
> sudo systemctl start redis
> curl -i localhost:3000/health
HTTP/1.1 200 OK
Content-Type: text/plain
Content-Length: 2
OK

> sudo systemctl stop redis
> curl -i localhost:3000/health
HTTP/1.1 503 Service Unavailable
Content-Type: text/plain
Content-Length: 2
KO
```

I use this with [Honeybadger](https://www.honeybadger.io) with their Uptime Monitoring feature and in case something happens I can receive an alert in any messaging service.

This is pretty basic and I use it as part of other tools, but maybe you don't need that extra gem dependency if you can check the health of your application like this.
