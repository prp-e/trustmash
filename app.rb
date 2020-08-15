require 'sqlite3'
require 'sinatra'
require 'json'

input_strings = File.open("clean_text.txt", 'r')
phrases = []

input_strings.readlines.each do |line|
    phrases << line 
end

db = SQLite3::Database.open('db.sqlite3')
db.execute("DROP TABLE IF EXISTS trusts")
db.execute("CREATE TABLE IF NOT EXISTS trusts(id INTEGER PRIMARY KEY AUTOINCREMENT, trusty_case TEXT, rating INTEGER)")

phrases.each do |string|
    db.execute("INSERT INTO trusts (trusty_case, rating) values (\"#{string}\", 0)")
end

get '/' do 
    'Nothing special'
end 

get '/:id' do 
    content_type :json 
    text = db.execute("SELECT trusty_case FROM trusts WHERE id=#{params[:id]}")
    {:id => params[:id], :text => text}.to_json
end

get '/rate/:competitor_1/:competitor_2' do 
    content_type :json 
    db.execute("UPDATE trusts SET rating = rating + 1 WHERE id=#{params[:competitor_1]}")
    db.execute("UPDATE trusts SET rating = rating -1 WHERE id=#{params[:competitor_2]}")

    {"status" => "ok"}.to_json 
end 