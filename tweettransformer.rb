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
  def trim140
    tweet = self
    while tweet.length>140
      tweetwords=tweet.split(' ')
      tweet=tweetwords[0..-2].join(' ') << "..."
 
    end
    return tweet
  end
  
  
  def georgealyser
    tgr = EngTagger.new
    tagged = tgr.add_tags(self)
    georgewords = ["Costanza", "George", "Costanza", "George", "Vandelay Industries", "George Costanza", "George Costanza", "Importer/Exporter"]
    nouns = tgr.get_nouns(tagged)
    nouns.delete_if {|key, value| key[0]==":"}
    nouns.delete_if {|key, value| key[0]=="@"}
    nouns.delete("http")
    b = nouns.keys.sample
    c = nouns.keys.sample
    self.gsub!("Alain","George")
    self.gsub!("de Botton","Costanza")
    self.gsub!("Religion for Atheists","Religion for Marine Biologists") 
    self.gsub!("Atheists","marine biologists") 
    self.gsub!("atheists","marine biologists") 
    self.gsub!(b,georgewords.sample)
    self.gsub!(c,georgewords.sample)

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
    return splittweet.join(" ").reverse.gsub(" ,",", ")
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
    
  
  
  
end
