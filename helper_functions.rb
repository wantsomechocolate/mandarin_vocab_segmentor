#helper_functions.rb
require 'set'

module HelperFunctions

    USERDICT = {'小红帽'=>{'type'=>'user'},'灰狼'=>{'type'=>'user'}}
    COMMDICT = {'每一次'=>{'type'=>'comm','def' => 'every time'}}
    STOPWORDS_LM = Set.new(["\n"])
    STOPWORDS_TK = Set.new(["（" , "）" , "〈" , "〉" , "《" , "》" , "［" , "］" , "｛" , "｝" , "｜" , "{" , "}" , "[" , "]" , "＜" , "＞" ,
                    ## Puncuation
                    "、" , "。" , "！" , "-" , "“" , "”" , "," , "." , ":" , "，" , "：" , "；" , "？" , "!" , "?" , "." ,
                    ## Numbers
                    "０" , "１" , "２" , "３" , "４" , "５" , "６" , "７" , "８" , "９" ,
                    "0" , "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" ,
                    ## English Letters
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                    ## Other
                    "\n" , " " , "＠" , "～" , "￥" , "＆" , "＊" , "＋" , "＃" , "＄" , "％" , "︿"])

    def add_or_increment(output,text,type)
        if output.has_key?(text)
            output[text]['count']+=1
        else
            output[text] = {
                'count'   =>  1      ,
                'type'    =>  type   ,
            }
        end  
    end

    ## Tried to add a process unknown function but ran into some trouble with scope

    ## Should definitely add something here for printing output to CSV

    ## Perhaps even something for printing output to Pleco flash card format



    def to_csv(output, filepath, headers = ['word','count','type'])
        ## CSV Output 
        #output = new_token_dict.merge(output)
        if output.length > 0 
            #headers = ['word','count','type']
            #filepath = 'C:\Users\JamesM\Projects\Programming\MandarinVocab\outputfiles\fakelove\fakelove_lm'+timestamp+'.csv'
            CSV.open(filepath, 'w') do |csv|
                csv.to_io.write "\uFEFF" # use CSV#to_io to write BOM directly 
                csv << headers
                output.each do |word, attributes|    
                    csv << [word, *attributes.values_at("count", "type")]
                end
            end
        end
    end




end

=begin
class Stopwords

    def initialize
    end
                ## Parens
    @@stopwords = Set["（" , "）" , "〈" , "〉" , "《" , "》" , "［" , "］" , "｛" , "｝" , "｜" , "{" , "}" , "[" , "]" , "＜" , "＞" ,
                ## Puncuation
                "、" , "。" , "！" , "-" , "“" , "”" , "," , "." , ":" , "，" , "：" , "；" , "？" , "!" , "?" , "." ,
                ## Numbers
                "０" , "１" , "２" , "３" , "４" , "５" , "６" , "７" , "８" , "９" ,
                "0" , "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" ,
                ## English Letters
                "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                ## Other
                "\n" , " " , "＠" , "～" , "￥" , "＆" , "＊" , "＋" , "＃" , "＄" , "％" , "︿"]

    attr_accessor :stopwords
end
=end
