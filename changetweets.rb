require 'twitter'
require './tweettransformer.rb'

def twitter
  @twitter ||= Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['YOUR_CONSUMER_KEY']
    config.consumer_secret = ENV['YOUR_CONSUMER_SECRET']
    config.access_token = ENV['YOUR_OAUTH_TOKEN']
    config.access_token_secret = ENV['YOUR_OAUTH_TOKEN_SECRET']
  end
end

def stream
  @stream ||= Twitter::Streaming::Client.new do |config|
    config.consumer_key = ENV['YOUR_CONSUMER_KEY']
    config.consumer_secret = ENV['YOUR_CONSUMER_SECRET']
    config.access_token = ENV['YOUR_OAUTH_TOKEN']
    config.access_token_secret = ENV['YOUR_OAUTH_TOKEN_SECRET']
  end
end


original_id = twitter.user("edjeff").id
stream.filter(follow:"#{original_id}") do |object|
  if object.is_a?(Twitter::Tweet)
    puts object
    puts object.inspect
    if object.user.id == original_id
      finaltweet = object.text.send(ENV['TRANSLATE_TYPE']).trim140
      puts finaltweet
    
      if finaltweet!="no nouns"
         sleep rand(1..120)
         twitter.update(finaltweet)
      end

      puts "DONE A TWET"
    else
      puts "NOT MY TWET"
    end
  end
end

