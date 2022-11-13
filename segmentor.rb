module Segmentor


	## Loop through all starting points
	## Find the longest word found from each starting point, update right max
	## Add word to output if word pushes passed right max
	## If you encounter characters that do not result in a dictionary entry
	    ## If they push passed right max, Add them to a running list of unknown characters
	## If you find a stop word or a dictionary word, add current state of unknown to output and blank it

	def longest_matching(text, word_trie = {}, stopwords = {}, config={} )

		trie = word_trie
		stopwords_lm = stopwords

		output = {}
		i = 0
		unknown = ""
		right_max = 0
		stopwords_lm = stopwords
		#puts stopwords_lm.include?("\n")

		## start going through characters 1 by 1
		while i<text.length
		    parent_node = trie
		    cur_string = ""
		    longest_word = ""
		    j = 0 #for traversing the tree
		    cur_char = text[i+j,1]

		    #if the char is a newline (maybe I should have stopwords instead?)
		    if stopwords_lm.include?(cur_char)

		        # Process Unknown
		        if unknown.length > 0
		            add_or_increment(output,unknown,'unknown')
		            unknown = ""
		        end

		    else
		        ## while the parent node continues to have the next character as a child
		        while parent_node.children.has_key?(cur_char)
		            cur_string += cur_char #does no mean you have found a word yet

		            ## If the node for the current character is a word then update longest word to equal the current string
		            if parent_node.children[cur_char].is_word
		                longest_word = cur_string
		            end

		            ## update parent node, increase j, and update cur_char for next round
		            parent_node = parent_node.children[cur_char]
		            j+=1
		            cur_char = text[i+j,1]
		        end

		        ## after this process, if the longest_word is empty it means whatever you found wasn't in the dictionary
		        ## If the unknown character doesn't push past right_max, then just move on
		        ## If it does, then add the character you started on (where i is) to unknown and continue on
		        if longest_word == "" and i+1 > right_max
		            unknown += text[i,1]
		            right_max+=1
		        
		        ## You found a word!
		        else

		            ## Process unknown
		            if unknown.length > 0
		                add_or_increment(output,unknown,'unknown')
		                unknown = ""
		            end
		            
		            ## Then add the word you found IF right > right_max 
		            ## (e.g. if you parse 中国 don't add 国 right after adding 中国, but if parsing 中国家 do add 中国 and 国家)
		            if i + longest_word.length > right_max
		                add_or_increment(output,longest_word,'trie')
		                right_max = i+longest_word.length
		            end    
		        end
		    end
		    i+=1
		end

		return output
	end


end