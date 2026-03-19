require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'bcrypt'
require_relative './model.rb'

enable :sessions
@adminness = false

get('/') do
  rocks = SQLite3::Database.new("db/rocks.db")
  rocks.results_as_hash = true
  slim(:index)
end

get('/login') do
  slim(:login)
end

get('/my_rocks') do
  if session[:user_id] == nil
    redirect('/login')
  end
  rocks = SQLite3::Database.new("db/rocks.db")
  rocks.results_as_hash = true
  @personal_rocks = rocks.execute("SELECT * FROM rocks WHERE owner_id = ? ORDER BY id DESC", [session[:user_id]]) #lägg till krav på inloggning
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
  rocks.execute("INSERT INTO rocks (name, description, rock_type, owner_id, img, publicness) VALUES (?, ?, ?, ?, ?, ?) ", [new_rock, description, rock_type, session[:user_id], image, publicness])
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

post("/new_user") do
  @wrong_password = false
  username = params[:username]
  geologstatus = params[:geologstatus]
  password = params[:password]
  confirm_password = params[:confirm_password]

  users = SQLite3::Database.new("db/users.db")
  result=users.execute("SELECT id FROM users WHERE username=?", username)

  if result.empty?
      if password==confirm_password
          password_digest=BCrypt::Password.create(password)
          users.execute("INSERT INTO users(username, password, adminstatus, geologstatus) VALUES(?,?, 0, ?)", [username, password_digest, geologstatus])
          redirect('/')
      else
          @wrong_password = true
          redirect('/register')
      end
  else
      redirect('/') #fixa loginsida här sen
  end
end

get('/register') do
  slim(:register)
end

get('/login') do
  slim(:login)
end

post('/login') do
  @wrong_login = false
  username = params["username"]
  password = params["password"]


  users = SQLite3::Database.new("db/users.db")
  users.results_as_hash = true
  result=users.execute("SELECT id, password FROM users WHERE username=?", username)


  if result.empty?
      @wrong_login = true

      redirect('/login')
  end

  user_id = result.first["id"]
  password_digest = result.first["password"]

    if BCrypt::Password.new(password_digest) == password
      session[:user_id] = user_id
      redirect('/')
  else
      @wrong_login = true 
      redirect('/login')
  end
      
end

get('/browse') do
  users = SQLite3::Database.new("db/users.db")
  users.results_as_hash = true
  rocks = SQLite3::Database.new("db/rocks.db")
  rocks.results_as_hash = true
  @public_rocks = rocks.execute("SELECT * FROM rocks WHERE publicness = 'true' ORDER BY id DESC")
  if users.execute("SELECT adminstatus FROM users WHERE id = ?", session[:user_id]) == [{"adminstatus"=>"true"}]
    @adminness = true
  end 
  slim(:browse)
end

post('/logout') do
  session.clear
  redirect('/')
end

get('/my_boxes') do
  if session[:user_id] == nil
    redirect('/login')
  end
  boxes = SQLite3::Database.new("db/boxes.db")
  boxes.results_as_hash = true
  @personal_boxes = boxes.execute("SELECT * FROM boxes WHERE owner_id = ? ORDER BY id DESC", [session[:user_id]])
  slim(:my_boxes)
end

get('/:id/box') do
  id = params["id"]
  boxes = SQLite3::Database.new("db/boxes.db")
  boxes.results_as_hash = true
  @boxinfo = boxes.execute("SELECT * FROM boxes WHERE id = ?", [id]).first
  p @boxinfo
  slim(:box)
end