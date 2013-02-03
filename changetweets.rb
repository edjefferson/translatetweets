require 'twitter'
require 'pg'

require './tweettransformer.rb'




if ARGV.count <= 2
  puts "include some arguments you idoit" 
  abort
   
end


puts ARGV[1].class


  
  
  
  
  
  LeTwitter = Twitter.configure do |config|
    config.consumer_key = ENV['YOUR_CONSUMER_KEY']
    config.consumer_secret = ENV['YOUR_CONSUMER_SECRET']
    config.oauth_token = ENV['YOUR_OAUTH_TOKEN']
    config.oauth_token_secret = ENV['YOUR_OAUTH_TOKEN_SECRET']
  end
  

  LatestTweet = LeTwitter.search("from:#{ENV['TWITTERHANDLE']}", :count => ARGV[0][0], :result_type => "recent").results.reverse.each do |status|
    conn = PGconn.connect(ENV['DB_ADDRESS'], ENV['DB_PORT'], '', '', ENV['DB_NAME'], ENV['DB_USER'], ENV['DB_PASSWORD'])
    readout = conn.query("SELECT * from tweets").values.to_a
    @last50 = Array.new
    readout.each_with_index do |x , y|
      
      @last50 << x[0]
    end  
    

    tweetid=status.id
    tweettext=status.text
    sid=tweetid.to_s
    
    if !@last50.include?sid
      

      finaltweet=tweettext.send(ARGV[1]).trim140
      puts finaltweet
      
      Twitter.update(finaltweet)

      

      if conn.query("select  count(id) from tweets;").values.to_a[0][0].to_i>=50
        conn.query("DELETE FROM tweets using (select min(id) from tweets) r where id=r.min;")
      end
      
      puts "DONE A TWET"
    
        conn.query("INSERT INTO tweets (id) VALUES (#{tweetid});")
      
      
      
    else
      puts "NOT DONE A TWET"

    
    end  
    conn.finish  
  end

 