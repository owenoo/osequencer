
require "pry"
require 'digest/sha1'


# Contains class methods for processing an internal file called "dictionary.txt".
# Outputs two files in the /app/assets/text/output folder called "words" and "sequences"
# Sequences.txt contains each unique set of 4-char long strings parsed from the internal file
# Words.txt contains the derived word used for parsing the corresponding sequence
# e.g. Sequences.txt line# 30 will contain a sequence found in the word displayed on line#30 of Words.txt
class DictionaryReader
  
  @sequencer = Sequencer.new
  @words_seen = {}
  
  # An optional method to use if the dictionary contains very long "words" like DNA sequences e.g. AAAGTCTGAC... + 40 more chars
  def self.getSHA input
    
    sha = Digest::SHA1.hexdigest input
     
    return sha.to_sym
  end 
  
  def self.process 
    
    baseUrl = "app/assets/text/output/"
    sFile = File.open(baseUrl + "sequences.txt", "w")
    wFile = File.open(baseUrl + "words.txt", "w")
    
    # Read line by line
    File.open("app/assets/text/dictionary.txt", "r").each_line do |line|
      
      line = line.chomp # remove any newline chars
      
      #if word contains less than 4 letters [A-z], skip it
      next if line.count("A-Za-z") < 4
      
      fingerprint = line.to_sym # you could SHA this if the strings were very long, like DNA sequences
      
      # Process line if it is unique
      if(@words_seen.has_key?(fingerprint) == false)
          @words_seen[fingerprint] = true
          
          sequenceCollection = Sequencer.breakIntoSegments(line);
          
          sequenceCollection.each do |s|
            sFile.write(s + "\n")
            wFile.write(line + "\n")
          end

        end #process seq
        
    end # process line
    
    sFile.close
    wFile.close
    
    puts "Sequencing complete!"
    
  end # process
  
end