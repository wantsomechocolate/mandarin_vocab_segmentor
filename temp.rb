
filepath = 'C:\Users\JamesM\Projects\Programming\MandarinVocab\wordlists\global_wordfreq.release_UTF-8.txt'
lines = File.foreach(filepath, encoding: 'bom|utf-8').first(10)

line = lines[0].strip()

puts line.split()[0]