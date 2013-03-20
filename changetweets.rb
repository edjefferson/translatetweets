require 'twitter'
require 'mysql'

require './tweettransformer.rb'
require './twitterpatch.rb'




if ARGV.count < 1
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
  



  #heroku config:add DB_HOST= DB_USER= DB_PW= DB_NAME=
  con = Mysql.new ENV['DB_HOST'],ENV['DB_USER'],ENV['DB_PW'],ENV['DB_NAME']
  
  

  result = con.query("select lasttweet from lasttweet where id=1")

  readout = result.fetch_row

  puts readout[0].to_i 
  LatestTweet = LeTwitter.search("from:#{ENV['TWITTERHANDLE']}", :result_type => "recent", :since_id => readout[0].to_i  ).results.reverse.each do |status|
    
    
    
   
    

    tweetid=status.id
    tweettext=status.text
    sid=tweetid.to_s
    
      begin
      
      
      finaltweet=tweettext.send(ARGV[0]).trim140
      puts finaltweet

        
      if finaltweet!="no nouns"
         Twitter.update(finaltweet)
      end
      

      

   
      
      puts "DONE A TWET"
    
        con.query("update lasttweet set lasttweet=#{tweetid} where id=1")
      rescue Twitter::Error::Forbidden  
        
        puts "DUPE"
      end
      
      
      
    
      

    
      
    
  end
con.close
 