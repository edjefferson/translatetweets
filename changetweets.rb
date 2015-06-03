require 'twitter'
require 'pg'
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

#heroku config:add DB_HOST= DB_USER= DB_PW= DB_NAME=

=begin

con = PGconn.new(ENV['DB_STRING'])


result = con.exec("select lasttweet from lasttweet where id=1")

readout = result.fetch_row

=end

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



