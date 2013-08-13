require 'grape'
require 'redis'
require 'securerandom'

module UrlCache
  def redis
    @redis ||= Redis.new
  end

  def grurl_key(action, key)
    "GrURL:#{action}:#{key}"
  end

  def random_key
    key = ""
    begin
      key = SecureRandom.urlsafe_base64
    end while exists?(key)
    key
  end

  def record_click(key)
    redis.incr(grurl_key(:clicks, key)).to_s
  end

  def fetch(key, action = :shortened)
    redis.get(grurl_key(action, key))
  end

  def save(key, value)
    redis.set(grurl_key(:shortened, key), value)
  end

  def exists?(key, action = :shortened)
    redis.exists(grurl_key(action, key))
  end
end

module GrURL
  class API < Grape::API
    format :json
    helpers UrlCache

    get ':key' do
      url = fetch(params[:key])
      record_click(params[:key])
      redirect url
    end

    get ':key/info' do
      url = fetch(params[:key], :shortened)
      clicks = fetch(params[:key], :clicks) || '0'
      { clicks: clicks, long_url: url }
    end

    post '/' do
      if key = params[:key]
        if exists?(key)
          error!('Key taken', 500)
        else
          save(key, params.url)
          {
            key: key,
            short_url: "/#{key}",
            long_url: params.url
          }
        end
      else
        if url = params.url
          key = random_key
          save(key, url)
          { key: key, short_url: "/#{key}", long_url: url }
        else
          puts params
          puts params.url
          error!('No URL passed', 500)
        end
      end
    end
  end
end
