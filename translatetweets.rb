require 'twitter'
require 'pg'
require 'microsoft_translator'



translator = MicrosoftTranslator::Client.new(ENV['MTCLIENTID'], ENV['MTCLIENTSECRET'])





def my_strip(string, chars)
  chars = Regexp.escape(chars)
  string.gsub(/\A[#{chars}]+|[#{chars}]+\Z/, "")
end


  
  
  
  
  
  LeTwitter = Twitter.configure do |config|
    config.consumer_key = ENV['YOUR_CONSUMER_KEY']
    config.consumer_secret = ENV['YOUR_CONSUMER_SECRET']
    config.oauth_token = ENV['YOUR_OAUTH_TOKEN']
    config.oauth_token_secret = ENV['YOUR_OAUTH_TOKEN_SECRET']
  end
  

  LatestTweet = LeTwitter.search("from:#{ENV['TWITTERHANDLE']}", :count => 25, :result_type => "recent").results.reverse.each do |status|
    conn = PGconn.connect(ENV['DB_ADDRESS'], ENV['DB_PORT'], '', '', ENV['DB_NAME'], ENV['DB_USER'], ENV['DB_PASSWORD'])
    readout = conn.query("SELECT * from tweets").values.to_a
    @last25 = Array.new
    readout.each_with_index do |x , y|
      
      @last25 << x[0]
    end  
    

    tweetid=status.id
    tweettext=status.text
    sid=tweetid.to_s
    
    if !@last25.include?sid
      
      translatedtweet = translator.translate(tweettext,"en","fr","text/html")
      puts translatedtweet

    
      strippedtweet = my_strip translatedtweet.to_s, "[\\\""
      strippedtweet2 = my_strip strippedtweet.to_s, "\\\"]"
      
      splittweet=translatedtweet.split(' ')
      splittweet.each_with_index do |x, y|
        if splittweet[y][0,1]=="@"
          prefix=["le","la","un","une"].sample
          splittweet[y].gsub!("@","@#{prefix}")
        end
      end
      finaltweet=splittweet.join(" ")  
      if finaltweet.length<141
        puts finaltweet
        Twitter.update(finaltweet)
      else  
        puts finaltweet[0..143]
        Twitter.update(finaltweet[0..143])
      
      end
      

      if conn.query("select  count(id) from tweets;").values.to_a[0][0].to_i>25
        conn.query("DELETE FROM tweets using (select min(id) from tweets) r where id=r.min;")
      end
      
      puts "DONE A TWET"
    
        conn.query("INSERT INTO tweets (id) VALUES (#{tweetid});")
      
      
      
    else
      puts "NOT DONE A TWET"

    
    end  
    conn.finish  
  end

 