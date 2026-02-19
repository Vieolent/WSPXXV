require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'bcrypt'



get('/') do
  rocks = SQLite3::Database.new("db/rocks.db")
  rocks.results_as_hash = true
  slim(:index)
end