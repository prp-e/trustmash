require 'sqlite3'
require 'sinatra'
require 'json'

def elo_rating(rating_a, rating_b)
    probablity = 1/(1 + 10**((rating_b - rating_a)/400))
    return probablity
end

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

configure do 
    enable :cross_origin 
end  

before do 
    response.headers['Access-Control-Allow-Origin'] = '*'
end 

options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
end


get '/' do 
    'Nothing special'
end 

get '/:id' do 
    content_type :json 
    text = db.execute("SELECT trusty_case FROM trusts WHERE id=#{params[:id]}")[0][0]
    {:id => params[:id], :text => text}.to_json
end

get '/rate/:competitor_1/:competitor_2' do 
    content_type :json
    db.execute("UPDATE trusts SET rating = rating + 1 WHERE id=#{params[:competitor_1]}")
    db.execute("UPDATE trusts SET rating = rating -1 WHERE id=#{params[:competitor_2]}")

    redirect 'http://localhost:8000'
end 

get '/trust_rate/:id_1/:id_2' do 
    content_type :json 
    rating_a = db.execute("SELECT rating FROM trusts WHERE id=#{params[:id_1]}")
    rating_b = db.execute("SELECT rating FROM trusts WHERE id=#{params[:id_2]}")
    text_a = db.execute("SELECT trusty_case FROM trusts WHERE id=#{params[:id_1]}")
    text_b = db.execute("SELECT trusty_case FROM trusts WHERE id=#{params[:id_2]}")
    rating_a = rating_a[0][0].to_f 
    rating_b = rating_b[0][0].to_f
    rate_a = elo_rating(rating_a, rating_b)
    rate_b = elo_rating(rating_b, rating_a)

    {
        "competitor_1" => {"rating" => rating_a, "text" => text_a, "probablity" => rate_a},
        "competitor_2" => {"rating" => rating_b, "text" => text_b, "probablity" => rate_b}
}.to_json
end 