# encoding: UTF-8

require 'tradsim'

output_fh = File.open('C:\Users\JamesM\Projects\Programming\MandarinVocab\outputfiles\output.txt', 'w')

File.open('C:\Users\JamesM\Projects\Programming\MandarinVocab\wordlists\global_wordfreq.release_UTF-8.txt', 'r') do |fh|
  fh.each_line do |line|
    word, freq = line.split("\t")
    if Tradsim::to_sim(word) != word
    	output_fh.write(word,"\t",freq)
    end
  end
end

output_fh.close()