#tokinizer.rb
module Tokenizer

	## TOKINIZATION

	## I want to update this algorithm
	## Basically, I want to start with tokens of length 1
	## that's basically just bucketing all the characters
	## then I want to see for each bucket if I keep expanding out, how far can I go in both directions until I only have 1 match
	## if I do this for every bucket, for many of the words, I'll arrive at the same thing after the expansion, so take a set?
	## seems very brute. There must be some better way, for now just putting an absurdly high max_length produces the same output
	## for example, repative song lyrics benefit from this. 

	## Needs to be passed the text obviously, and the total dictionary (so it can ignore dictionary words)
	## but could also use some configuration information like the max_token_length, min_token_length, count cutoff

	## The below alg will return all tokens from length min_token_length to max_token_length that:
	    ## Are not completely contained within other tokens of greater length
	    ## Appear less than min count, regardless of length
	    ## Are already in the total dictionary
	## Tokens will not contain stopwords

	def tokenize( text, stopwords={}, word_dict={}, config={'min_length'=>2,'max_length'=>20,'min_count'=>1} )

		token_dict = {}

		max_length = config['max_length']
		min_length = config['min_length']
		min_count = config['min_count']

		k=0
		for left in text.length.times
		    for k in max_length.times
		        right = k+1
		        new_char = text[left+k,1]
		        if stopwords.include?(new_char) or left+right > text.length
		            break
		        else
		            token = text[left,right]
		            add_or_increment(token_dict,token,'token')
		        end
		    end
		end

		new_token_dict = {}
		for key1 in token_dict.keys()
		    ##If you only found less than min_count of this token or 
		    # it's already a dictionary word OR it's too short, then skip it
		    if token_dict[key1]['count']<min_count or word_dict.include?(key1) or key1.length < min_length
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

		return token_dict
	end
end