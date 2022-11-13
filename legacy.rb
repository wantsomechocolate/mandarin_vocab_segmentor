## IMPORTS
require 'set'
require 'csv'
require_relative 'auxiliary'
require_relative 'data_structures'

include HelperFunctions
include DataStructures

## FETCHING THE STOPWORDS SET (FOR TOKINIZATION)
include StopWords
stopwords = STOPWORDS


## CREATING THE GLOBAL DICT

## Get data from a file, this will eventually come from active record
#filepath = 'C:\Users\JamesM\Projects\Programming\MandarinVocab\wordlists\globalsortedbyfreq.csv'
#lines = File.foreach(filepath).first(600000)

#global_dict = {}
#for line in lines;
#    line = line.strip()
#    line = line.split(',')
#    global_dict[line[0]] = {'freq'=>line[1],'ln(freq)'=>line[2],'hsk'=>line[3]}
#end

trie,global_dict = build_trie_and_hash()


## USER DICT
Include UserDict
user_dict = Hash.new()
user_dict['小红帽']={}
user_dict['灰狼']={}

user_dict_set = Set.new()
for key in user_dict.keys()
    user_dict_set.add(key[0,1])
end

user_dict_list = user_dict.keys
user_dict_list = user_dict_list.sort_by(&:length).reverse!

##Combine the dicts
total_dict = user_dict.merge(global_dict) ## apparently this gives global dict priority in case the key already exists

## INPUT TEXT
text = File.read('C:\Users\JamesM\Projects\Programming\MandarinVocab\inputfiles\sampleinput2.txt')



## TOKINIZATION
## The below alg will return all tokens from length 1 to max_token_lengtht that:
    ## Are not completely contained within other tokens of greater length
    ## Appear only once, regardless of length
    ## Are already in the total dictionary (default+user)
## This accomplishes my goal of finding words that do not appear in the dictionary, but appear in the text multiple times
## Later on I could also consider going through and looking at the text after replacing all dictionary words with a separator
## and just returning a list of the results, that might be better than tokenizing actually.
## But I actually can't remove all dictionary words because sometimes they will overlap.  

token_dict = {}

## I think it would make sense to have the max token length be determined by whether or not tokens of the longest length can be extended
## and still have a count greater than 1. 
max_token_length = 10
k=0
for left in text.length.times
    for k in max_token_length.times
        right = k+1
        new_char = text[left+k,1]
        if stopwords.include?(new_char) or left+right > text.length
            break
        else
            token = text[left,right]
            add_or_increment(token_dict,token,'token',total_dict)
        end
    end
end

new_token_dict = {}
for key1 in token_dict.keys()
    ##If you only found one of this token or it's already a dictionary word, then skip it
    if token_dict[key1]['count']==1 or total_dict.include?(key1)
    else
        keep = true
        for key2 in token_dict.keys()
            if key2.length > key1.length and key2.include?(key1) and token_dict[key2]['count'] >= token_dict[key1]['count']
                keep = false
                break
            end
        end
        if keep == true
            new_token_dict[key1] = token_dict[key1]
        end
    end
end
token_dict = new_token_dict



## THE BUSINESS
## Start at a char, if it's in stop words then add current state of unknown to output, reset unknown, and then add stop word to output
## If it's in the dict, continue adding characters as long as you still have a matching dict entry
## When you're done, add the current state of unknown to the output, blank unknown, then:
##   If you have reached a new "high point" in the document add the longest word you found to the output.
##   If you have not reached a new high point, it means that the longest word you found is still contained within a previously found word.
## If it's not a stop word or dictionary word, append it to unknown
## Move to the next character. 


## My assumption that all words in the dict have all of their index-0 substrings in the dictionary was wrong. 
## 一 for example does not appear in the dictionary by itself. 
## so i need to update the algorithm below so that I can still match things in the dict :/
## Do I want a trie? In order to build one I'd essentially need to add bridges to the csv as well 
## I'm also having some issues with unicode support. 


output = {}
unknown = ""
right_max = 0
left = 0

while left < text.length
    user_dict_flag = false
    char = text[left, 1]

    ## If first char matches any character in the user-dict set, then loop through words in the 
    ## user dict in length order and if you find a match, add unknown, blank it
    ## and then add this guy

    if user_dict_set.include?(char)
        ## check to see if any of the dict words are there, if they are then increment left by the lenth of the word - 1
        for word in user_dict_list
            if word == text[left,word.length]
                user_dict_flag = true
                ## Deal with unknown, add/increment, and break out of the loop
                if unknown != ""
                    add_or_increment(output,unknown,'unknown', global_dict)
                    unknown = ""
                end
                add_or_increment(output,word,'user',user_dict)
                left = left + word.length - 1
                break
            end
        end
    end

    ## if you found a user word then skip the rest of these checks
    if stopwords.include?(char) and user_dict_flag == false
        if unknown != ""
            add_or_increment(output,unknown,'unknown', global_dict)
            unknown = ""
        end
        ## I decided not to count stop words and add them to the output, seems silly
        #add_or_increment(output,char,'stop', global_dict)

    elsif global_dict.has_key?(char) and user_dict_flag == false # or user_dict.has_key?(char)
        if unknown != ""
            add_or_increment(output,unknown,'unknown', global_dict)
            unknown = ""
        end
        right = left + 2
        while global_dict.has_key?(text[left, right-left]) and right < text.length+1 #or user_dict.has_key?(text[left,right-left])
            right += 1
        end

        #Get the longest word determined via the above while loop
        right -= 1
        word = text[left,right-left]

        ## Add word if right > right_max (This is to avoid retuning the 国 in 中国 for example)
        if right > right_max
            if global_dict.has_key?(word)
                add_or_increment(output,word,'dict', global_dict)
            else
                add_or_increment(output,word,'user',user_dict)
            end
        end
        right_max = [right,right_max].max()
    else
        unknown+=char
    end
    left+=1
end

## If you end on unknown characters, it won't make it's way into output so you have to do it now
## I think it's important in case the entire entered text is unknown characters. 
if unknown != "";
    add_or_increment(output,unknown,'unknown', global_dict)
    unknown = ""
end



## CSV Output 
total_output = new_token_dict.merge(output)

headers = output.values[0].keys
headers.insert(0,'word')

timestamp = Time.now.to_i.to_s
filepath = 'C:\Users\JamesM\Projects\Programming\MandarinVocab\outputfiles\tcb\test'+timestamp+'.csv'

CSV.open(filepath, 'w') do |csv|
    csv.to_io.write "\uFEFF" # use CSV#to_io to write BOM directly 
    csv << headers
    total_output.each do |word, attributes|    
    csv << [word, *attributes.values_at("count", "type", "freq", "ln(freq)", "hsk")]
  end
end

=begin
headers = output.values[0].keys
headers.insert(0,'token')
CSV.open('output_tokens.csv', 'w') do |csv|
    csv.to_io.write "\uFEFF" # use CSV#to_io to write BOM directly 
    csv << headers
    token_dict.each do |word, attributes|    
    csv << [word, *attributes.values_at("count", "type", "freq", "ln(freq)", "hsk")]
  end
end
=end