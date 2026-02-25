require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'bcrypt'
require_relative './model.rb'


get('/') do
  rocks = SQLite3::Database.new("db/rocks.db")
  rocks.results_as_hash = true
  slim(:index)
end

get('/login') do
  slim(:login)
end

get('/my_rocks') do
  rocks = SQLite3::Database.new("db/rocks.db")
  rocks.results_as_hash = true
  @personal_rocks = rocks.execute("SELECT * FROM rocks ORDER BY id DESC")
  slim(:my_rocks)
end

get('/post_rock') do
  slim(:post_rock)
end

post('/new') do
  new_rock = params[:new_rock]
  description = params[:description]
  image = params[:image]
  rock_type = params[:rock_type]
  publicness = params[:publicness]
  rocks = SQLite3::Database.new("db/rocks.db")  
  rocks.execute("INSERT INTO rocks (name, description, rock_type, img, publicness) VALUES (?, ?, ?, ?, ?) ", [new_rock, description, rock_type, image, publicness])
  redirect('/my_rocks')
end

post("/:id/delete") do
  rocks = SQLite3::Database.new("db/rocks.db")
  removing = params[:id].to_i
  rocks.execute("DELETE FROM rocks WHERE id = ?", removing)
  redirect('/my_rocks')
end

get("/:id/edit") do
  id = params[:id].to_i
  db = SQLite3::Database.new("db/rocks.db")
  db.results_as_hash = true
  @selected_rock = db.execute("SELECT * FROM rocks WHERE id=?", id).first
  slim(:"/edit")
end

post("/:id/update") do
  db = SQLite3::Database.new("db/rocks.db")  
  id = params[:id].to_i
  name = params[:name]
  description = params[:description]
  image = params[:image]
  rock_type = params[:rock_type]
  publicness = params[:publicness]
  db.execute("UPDATE rocks SET name=?, description=?, rock_type=?, img=?, publicness=? WHERE id=?", [name, description, rock_type, image, publicness, id])
  redirect('/my_rocks')
end