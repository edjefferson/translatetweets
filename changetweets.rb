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
puts twitter.mentions_timeline[0].text
stream.filter(follow:"#{original_id}") do |object|
  if object.is_a?(Twitter::Tweet)
    finaltweet = object.text.send(ENV['TRANSLATE_TYPE']).trim140
    puts finaltweet
    
    if finaltweet!="no nouns"
       sleep rand(1..120)
       twitter.update(finaltweet)
    end

    puts "DONE A TWET"
  end
end

