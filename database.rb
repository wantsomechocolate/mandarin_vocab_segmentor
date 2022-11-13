
require 'active_record'

## Using Active Record

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :dbfile  => "sqlite3.db"
)



ActiveRecord::Schema.define do
    create_table :global_word_frequencies do |table|
        table.column :word, :string
        table.column :frequency, :integer
    end

    create_table :hsk_words do |table|
        table.column :word, :string
        table.column :old_level, :integer
        table.column :new_level, :integer
    end

    create_table :texts do |table|
    	table.column :user_id, :integer
    	table.column :name, :string
    	table.column :text, :text

    end

    create_table :tokens do |table|
    	table.column :text_id, :integer
    	table.column :name, :string
    	table.column :count, :integer
    	table.column :type, :string #could be enumerated I suppose?

end



#Resource
#https://guides.rubyonrails.org/active_record_basics.html

class Product < ApplicationRecord
end


## each word in a wordlist
GlobalWordFrequency

BlogWordFrequency

LiteratureWorkFrequency

NewsWordFrequency

TechnologyWordFrequency

HskWord


global_word = GlobalWordFrequency.new()
global_word.frequency = 4












## Interfacing with sqlite3 directly

require 'sqlite3'

db = SQLite3::Database.open 'test.db'

## I probably don't want this
db.results_as_hash = true

db.execute "CREATE TABLE IF NOT EXISTS images(path TEXT, thumbs_up INT)"
db.execute "INSERT INTO images (path, thumbs_up) VALUES (?, ?)", 'image1.png', 0


# Assuming you have an images table created from the previous examples
db.execute "UPDATE images SET thumbs_up=? WHERE path=?", 1, 'image1.png'

image_path = 'image1.png'
results = db.query "SELECT path, thumbs_up FROM images WHERE path=?", image_path
# Alternatively, to only get one row and discard the rest,
# replace `db.query()` with `db.get_first_value()`.

first_result = results.next
if first_result
  puts first_result['thumb_up']
else
  puts 'No results found.'
end

# Alternatively, you can go through each result like this:
# results.each { |row| puts row.join(',') }