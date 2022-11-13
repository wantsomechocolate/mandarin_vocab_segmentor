## IMPORTS
require 'set'
require 'csv'

module DataStructures

    ##Should I try making a DAWG? directed acyclic word graph?

    ##Trie? Node Definition
    class Node

        def initialize(val,parent, is_word=false)
            @val = val
            @parent = parent
            @is_word = is_word
            @children = {}
        end

        attr_accessor :val
        attr_accessor :parent
        attr_accessor :is_word
        attr_accessor :children

    end


    ## CREATING THE GLOBAL DICT and GLOBAL TRIE
    def build_trie_and_hash(filepath = 'C:\Users\JamesM\Projects\Programming\MandarinVocab\wordlists\global_wordfreq.release_UTF-8.txt' ,
                        num_lines = 200000)

        ## Get data from a file, this will eventually come from active record
        filepath = filepath
        lines = File.foreach(filepath, :encoding => 'utf-8', mode: 'rb').first(num_lines)

        freq_dict = {}
        root_node = Node.new(nil,nil)

        for line in lines
            line = line.split
            freq_dict[line[0]] = line[1]
            word = line[0]
            parent_node = root_node
            for i in word.length.times
                char = word[i]
                siblings = parent_node.children
                if not siblings.has_key?(char)
                    parent_node.children[char] = Node.new(char,parent_node)
                end
                if i+1 == word.length
                   parent_node.children[char].is_word = true
                end
                parent_node = parent_node.children[char]
            end
        end
        return root_node, freq_dict
    end


    def build_hsk(csv_file)
        csv = CSV.read(csv_file)
        csv.shift
        hsk_dict = {}
        csv.each do |row|
            hsk_dict[row[0]] = row[1]
        end
        return hsk_dict
    end

    #root_node, freq_dict = build_trie_and_hash()

    #root_node.children.each do |key,node|
        #if node.is_word == true
            #puts "#{key}: parent=#{node.parent.val}, is_word=#{node.is_word}, children = #{node.children.length}"
        #end
    #end

    #puts root_node.children.length
    #puts freq_dict.length

end