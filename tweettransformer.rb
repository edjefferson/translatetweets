require 'microsoft_translator'
require 'dinosaurus'
require 'engtagger'

def my_strip(string, chars)
  chars = Regexp.escape(chars)
  string.gsub(/\A[#{chars}]+|[#{chars}]+\Z/, "")
end



class EngTagger
  NNS    = EngTagger.get_ext('nns')
  def get_plural_nouns(tagged)
    return nil unless valid_text(tagged)
    NNS
    trimmed = tagged.scan(NNS).map do |n|
      strip_tags(n)
    end
    ret = Hash.new(0)
    trimmed.each do |n|
      n = stem(n)
      next unless n.length < 100  # sanity check on word length
      ret[n] += 1 unless n =~ /\A\s*\z/
    end
    return ret
  end
  
end



class String
  
  
  def trekalyser
    tgr = EngTagger.new
    tagged = tgr.add_tags(self)
    #startrekwords = ["Picard", "Enterprise", "Data", "Beverley", "Riker", "Wesley", "Guinan", "Troi"]
    startrekwords = ["Costanza", "George", "Vandelay Industries"]
    nouns = tgr.get_nouns(tagged)
    b = nouns.keys.sample
    self.gsub!(b,startrekwords.sample)
    
    return self
  end

  def translatetweet
    @translator = MicrosoftTranslator::Client.new(ENV['MTCLIENTID'], ENV['MTCLIENTSECRET'])
    puts self
    puts self.class
  
    translatedtweet = @translator.translate(self,"en","fr","text/html")
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
    return splittweet.join(" ") 

  end
  
  def reversetweet
  
    strippedtweet = my_strip self.to_s, "[\\\""
    strippedtweet2 = my_strip strippedtweet.to_s, "\\\"]"
      
    splittweet=strippedtweet2.split(' ')
    splittweet.each_with_index do |x, y|
      if splittweet[y][0,1]=="@"
        splittweet[y].gsub!("@","")
        splittweet[y] << "@"
      elsif splittweet[y][0,4]=="http"
        splittweet[y].reverse!
      end
    end
    return splittweet.join(" ").reverse.gsub!(" ,",", ")
  end 
  
  def syntweet
    Dinosaurus.configure do |config|
      config.api_key = ENV['DINOAPIKEY']
    end
    
    strippedtweet = my_strip self.to_s, "[\\\""
    strippedtweet2 = my_strip strippedtweet.to_s, "\\\"]"
    
    splittweet=strippedtweet2.split(' ')
    newtweet = Array.new
    splittweet.each_with_index do |x, y|
      if splittweet[y][0,1]=="@"
        
        
       
        splittweet[y] << "@"
      end
      
      results = Dinosaurus.lookup(splittweet[y])
      if results.synonyms[0] == nil
        newtweet << splittweet[y]
      else
        newtweet << results.synonyms[0]
      
      end
      
      
    end
    return newtweet.join(" ")
    wait 20
    
  end
  
  def anttweet
    Dinosaurus.configure do |config|
      config.api_key = ENV['DINOAPIKEY']
    end
    
    strippedtweet = my_strip self.to_s, "[\\\""
    strippedtweet2 = my_strip strippedtweet.to_s, "\\\"]"
    
    splittweet=strippedtweet2.split(' ')
    newtweet = Array.new
    splittweet.each_with_index do |x, y|
      if splittweet[y][0,1]=="@"
        
        
       
        splittweet[y] << "@"
      end
      
      results = Dinosaurus.lookup(splittweet[y])
      if results.antonyms[0] == nil
        newtweet << splittweet[y]
      else
        newtweet << results.antonyms[0]
      
      end
      
      
    end
    return newtweet.join(" ")
    
  end
    
  
  def trim140
    tweet = self
    while tweet.length>140
      tweetwords=tweet.split(' ')
      tweet=tweetwords[0..-2].join(' ') << "..."
 
    end
    return tweet
  end
  
end
