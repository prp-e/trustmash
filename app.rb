require 'sqlite3'
require 'sinatra'
require 'json'

db = SQLite3::Database.open('db.sqlite3')
db.execute("CREATE TABLE IF NOT EXISTS trusts(id INTEGER PRIMARY KEY AUTOINCREMENT, trusty_case TEXT, rating INTEGER)")

get '/' do 
    'Nothing special'
end 