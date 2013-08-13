require 'grape'
require 'redis'

REDIS = Redis.new

module GrURL
	class API < Grape::API
	format :json

		get ':key' do
      url = REDIS.get("shortened-#{params[:key]}")
      incr("clicks-#{params[:key]}")
      redirect url
    end

    get ':key/info' do
      url = REDIS.get("shortened-#{params[:key]}")
      clicks = REDIS.get("clicks-#{params[:key]}") || '0'
      return { clicks: clicks, long_url: url }
    end

    post '/' do
      if params[:key]
        if REDIS.exists("shortened-#{params[:key]}")
          error!('Key taken', 500)
        else
          REDIS.set("shortened-#{params[:key]}", params[:url])
          return { key: params[:key], short_url: "/#{params[:key]}", long_url: params[:url] }
        end
      else
        key = incr('key')
        REDIS.set("shortened-#{key}", params[:url])
        return { key: key, short_url: "/#{key}", long_url: params[:url] }
      end
		end
	end
end

private

def incr(key)
  REDIS.set(key, 0) unless REDIS.exists(key)
  clicks = REDIS.incr(key).to_s
  return clicks
end