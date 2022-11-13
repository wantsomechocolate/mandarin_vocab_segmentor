## IMPORTS
require 'set'
require 'csv'
require_relative 'helper_functions'
require_relative 'data_structures'
require_relative 'tokenizer'
require_relative 'segmentor'

include HelperFunctions
include DataStructures
include Tokenizer
include Segmentor
#include StopWords


## FILE MANAGEMENT
timestamp = Time.now.to_i.to_s
headers = ['word','count','type']

## Input
fp_in = 'C:\Users\JamesM\Projects\Programming\MandarinVocab\inputfiles\fakelove.txt'

## Output
## Directory
#dir_out = File.join(File.dirname(File.dirname(fp_in)),"outputfiles",File.basename(fp_in,File.extname(fp_in)))
dir_out = File.join('C:\Users\JamesM\Projects\Programming\MandarinVocab\outputfiles',File.basename(fp_in,File.extname(fp_in)))

## Token output file
fn_out_tk = File.basename(fp_in,File.extname(fp_in))+'_tk_'+timestamp+'.csv'
fp_out_tk = File.join(dir_out,fn_out_tk)

## Longest Matching output file
fn_out_lm = File.basename(fp_in,File.extname(fp_in))+'_lm_'+timestamp+'.csv'
fp_out_lm = File.join(dir_out,fn_out_lm)


## CREATING THE GLOBAL DICT AND TRIE. TRIE IS USED FOR SEGMENTATION. DICT IS USED FOR TOKINIZATION
trie,global_dict = build_trie_and_hash()


## User Dict
#include UserDict
user_dict = USERDICT

## Community Dict, For things that aren't in the word list put probably should be?
## like 每一次 every time?
#comm_dict = COMMDICT

## Combine all Dicts
total_dict = user_dict.merge(global_dict) ## apparently this gives global dict priority in case the key already exists


## INPUT TEXT
text = File.read(fp_in)


## TOKINIZATION
token_dict = tokenize(text, stopwords = STOPWORDS_TK, word_dict = total_dict )
to_csv(token_dict,fp_out_tk,headers)


## SEGMENTATION
output = longest_matching(text, word_trie = trie, stopwords = STOPWORDS_LM, config={} )
to_csv(output,fp_out_lm,headers)


## Combine the output dictionaries and write to a single file. 
## Output to a pleco import format?

#puts trie.children['多'].children.length

#freq = 0

#trie.children['多'].children.each do |child|
#    freq += child.freq
#end

#puts freq