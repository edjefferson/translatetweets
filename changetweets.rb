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

#heroku config:add DB_HOST= DB_USER= DB_PW= DB_NAME=

=begin

con = PGconn.new(ENV['DB_STRING'])


result = con.exec("select lasttweet from lasttweet where id=1")

readout = result.fetch_row

=end

=begin

readout = [1,2]

twitter.search("from:#{ENV['TWITTERHANDLE']}", :result_type => "recent", :since_id => readout[0].to_i  ).to_a.reverse.each do |status|
   tweetid=status.id
   tweettext=status.text
   sid=tweetid.to_s
 
   begin
      finaltweet=tweettext.send(ENV['TRANSLATE_TYPE']).trim140
      puts finaltweet

        
      if finaltweet!="no nouns"
         #Twitter.update(finaltweet)
      end

      puts "DONE A TWET"
    
      #con.exec("update lasttweet set lasttweet=#{tweetid} where id=1")
   rescue Twitter::Error::Forbidden  
        
      puts "DUPE"
   end
end

=end

