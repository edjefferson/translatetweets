require 'twitter'
require 'pg'

require './tweettransformer.rb'




if ARGV.count < 2
  puts ARGV.count
  puts "include some arguments you idoit" 
  abort
   
end





  
  
  
  
  
  LeTwitter = Twitter.configure do |config|
    config.consumer_key = ENV['YOUR_CONSUMER_KEY']
    config.consumer_secret = ENV['YOUR_CONSUMER_SECRET']
    config.oauth_token = ENV['YOUR_OAUTH_TOKEN']
    config.oauth_token_secret = ENV['YOUR_OAUTH_TOKEN_SECRET']
  end
  

  puts LeTwitter
  puts ENV['YOUR_CONSUMER_KEY']
  conn = PGconn.connect(ENV['DB_ADDRESS'], ENV['DB_PORT'], '', '', ENV['DB_NAME'], ENV['DB_USER'], ENV['DB_PASSWORD'])
  result = con.query("select lasttweet from lasttweet where id=1")

  readout = result.fetch_row


  LatestTweet = LeTwitter.search("from:#{ENV['TWITTERHANDLE']}", :result_type => "recent", :since_id => readout[0].to_i  ).results.reverse.each do |status|
    
    
    
   
    

    tweetid=status.id
    tweettext=status.text
    sid=tweetid.to_s
    
      begin
      
      
      finaltweet=tweettext.send(ARGV[1]).trim140
      puts finaltweet

        Twitter.update(finaltweet)

      

      

   
      
      puts "DONE A TWET"
    
        conn.query("INSERT INTO since (id) VALUES (#{tweetid});")
      rescue Twitter::Error::Forbidden  
        
        puts "DUPE"
      end
      
      
      
    
      

    
      
    
  end
conn.finish  
 