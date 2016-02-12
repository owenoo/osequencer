require 'digest/sha1'

# Contains class methods for breaking apart an input string into sequences of 4 characters.
# Discards any sequences containing illegal characters.
class Sequencer
  
  @sequences_seen = {}

  # An optional method to use if the sequences are going to be longer than a hash string
  def self.getSHA input
    
    sha = Digest::SHA1.hexdigest input
     
    return sha.to_sym
  end 

  #For every 4 contiguous characters in the string, add to return obj if it
  #doesn't exist in our lookup table
  # Precondition: input should always be >= 4 characters
  def self.breakIntoSegments input
    words = []
    loopCount = input.length - 4 #clamp this so it's not negative just in case
    if loopCount < 0
      loopCount = 0
    end
    
    (0..loopCount).each do |i|
      
      currentSegment = input[i..i+3]
      fingerprint = currentSegment.to_sym
      
      if(@sequences_seen.has_key?(fingerprint) == false) 
          @sequences_seen[fingerprint] = true
          words.push(currentSegment)
      end
      
    end
    
    # discard segments that violate rule [A-z] exclusivity
    # symbols chosen based on looking at the example data
    words.delete_if {|x| x.match /[,.&']/ }
    
    return words
    
  end

end

