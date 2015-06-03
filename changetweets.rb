require 'twitter'
require 'pg'
require 'clockwork'
require './tweettransformer.rb'
require './twitterpatch.rb'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  # handler receives the time when job is prepared to run in the 2nd argument
  # handler do |job, time|
  #   puts "Running #{job}, at #{time}"
  # end

  every(10.minutes, changetweet)
end

def changetweet

LeTwitter = Twitter.configure do |config|
    config.consumer_key = ENV['YOUR_CONSUMER_KEY']
    config.consumer_secret = ENV['YOUR_CONSUMER_SECRET']
    config.oauth_token = ENV['YOUR_OAUTH_TOKEN']
    config.oauth_token_secret = ENV['YOUR_OAUTH_TOKEN_SECRET']
end

#heroku config:add DB_HOST= DB_USER= DB_PW= DB_NAME=
con = PGconn.new(ENV['DB_STRING'])


result = con.exec("select lasttweet from lasttweet where id=1")

readout = result.fetch_row


LatestTweet = LeTwitter.search("from:#{ENV['TWITTERHANDLE']}", :result_type => "recent", :since_id => readout[0].to_i  ).results.reverse.each do |status|
   tweetid=status.id
   tweettext=status.text
   sid=tweetid.to_s
 
   begin
      finaltweet=tweettext.send(ENV['TRANSLATE_TYPE']).trim140
      puts finaltweet

        
      if finaltweet!="no nouns"
         Twitter.update(finaltweet)
      end

      puts "DONE A TWET"
    
      con.exec("update lasttweet set lasttweet=#{tweetid} where id=1")
   rescue Twitter::Error::Forbidden  
        
      puts "DUPE"
   end
end

end
 