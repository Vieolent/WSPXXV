require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'bcrypt'

require_relative './model.rb'

enable :sessions
@adminness = false

before('/protected/*') do
   if session[:user_id] ==  nil
    #Ingen användare är inloggad
    redirect('/users/login')
  end
 end
 

get('/') do
  db = connect_db()
  slim(:start)
end

get('/users/login') do
  slim(:"users/login")
end

get('/protected/rocks/private_index') do
  db = connect_db()
  @personal_rocks = personal_rockage(db, session[:user_id]) 
  slim(:"rocks/private_index")
end

get('/rocks/new') do
  slim(:"rocks/new")
end

post('/new') do
  new_rock = params[:new_rock]
  description = params[:description]
  image = params[:image]
  rock_type = params[:rock_type]
  publicness = params[:publicness]
  db = connect_db() 
  new_shiny_rock(db, new_rock, description, rock_type, session[:user_id], image, publicness)
  redirect('/protected/rocks/private_index')
end

post("/:id/delete") do
  removing = params[:id]
  db = connect_db()
  if find_adminness(db, session[:user_id]).first["adminstatus"] == "true" || session[:user_id].to_i == select_id_of_rock_owner(db, removing).first["owner_id"].to_i
    delete_rock(db, removing)
    redirect('/protected/rocks/private_index')
  else
    redirect('/')
  end
end

get("/rocks/:id/edit") do
  id = params[:id].to_i
  db = connect_db()
  if find_adminness(db, session[:user_id]).first["adminstatus"] == "true" || session[:user_id].to_i == select_id_of_rock_owner(db, id).first["owner_id"].to_i
    @selected_rock = select_rock(db, id)
    slim(:"rocks/edit")
  else
    slim(:start)
  end
end

post("/:id/update") do
  db = connect_db()
  id = params[:id].to_i
  name = params[:name]
  description = params[:description]
  image = params[:image]
  rock_type = params[:rock_type]
  publicness = params[:publicness]
  update_rock(db, name, description, rock_type, image, publicness, id)
  redirect('/protected/rocks/private_index')
end

post("/new_user") do
  session[:wrong_password] = false
  session[:bad_password] = false
  username = params[:username]
  geologstatus = params[:geologstatus]
  password = params[:password]
  confirm_password = params[:confirm_password]

  if password.length < 5 || password.length > 25
    session[:bad_password] = true
    redirect('users/register')
  end

  db = connect_db()
  result = select_user(db, username)

  if result.empty?
      if password == confirm_password
          password_digest = BCrypt::Password.create(password)
          add_user(db, username, password_digest, geologstatus)
          redirect('/')
      else
          session[:wrong_password] = true
          redirect('users/register')
      end
  else
      redirect('/') 
  end
end

get('/users/register') do
  slim(:"users/register")
end

get('/users/login') do
  slim(:"users/login")
end

post('/login') do
  @wrong_login = false
  username = params["username"]
  password = params["password"]


  db = connect_db()
  result = select_password_of_user(db, username)


  if result.empty?
      @wrong_login = true

      redirect('/users/login')
  end

  user_id = result.first["id"]
  password_digest = result.first["password"]

    if BCrypt::Password.new(password_digest) == password
      session[:user_id] = user_id
      redirect('/')
  else
      @wrong_login = true 
      redirect('/users/login')
  end
      
end

get('/rocks/public_index') do
  db = connect_db()
  @public_rocks = select_public_rocks(db)
  if find_adminness(db, session[:user_id]) == [{"adminstatus"=>"true"}]
    @adminness = true
  end 
  slim(:"rocks/public_index")
end

post('/logout') do
  session.clear
  redirect('/')
end

get('/protected/boxes/index') do
  db = connect_db()
  @personal_boxes = select_personal_boxes(db, session[:user_id])
  slim(:"boxes/index")
end

get('/boxes/new') do
  slim(:"boxes/new")
end

get('/boxes/:id') do
  id = params["id"]
  session[:box_id] = id
  db = connect_db()
  @boxinfo = find_boxinfo(db, id)
  @internalrocks = find_internal_rocks(db, id, session[:user_id])
  slim(:"boxes/show")
end

post("/boxes/:box_id/:rock_id/delete_from_box") do
  db = connect_db()
  removing = params[:box_id].to_i
  removingage = params[:rock_id].to_i
  delete_from_boxes(db, removingage, removing)
  redirect('/protected/boxes/index')
end

post('/new_box') do
  new_box = params[:new_box]
  description = params[:description]
  publicness = params[:publicness]
  db = connect_db()
  create_new_box(db, new_box, description, session[:user_id], publicness)
  redirect('/protected/boxes/index')
end

get('/boxes/add_rock') do
  db = connect_db()
  @public_rocks = select_public_or_owned_rocks(db, session[:user_id])
  slim(:"rocks/add_rock")
end

post('/add_rocks') do
  i = 0
  while i < @public_rocks.length 
    if params["rocks_selected_#{i}"]
    end
  end
  added_rocks = params[:rocks_selected_1]
  p added_rocks

  redirect('/protected/boxes/index')
end