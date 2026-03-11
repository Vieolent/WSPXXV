require 'sqlite3'
require 'bcrypt'

rocks = SQLite3::Database.new("rocks.db")


def seed!(db)
  puts "Using db file: db/todos.db"
  puts "🧹 Dropping old tables..."
  drop_tables(db)
  puts "🧱 Creating tables..."
  create_tables(db)
  puts "🍎 Populating tables..."
  populate_tables(db)
  puts "✅ Done seeding the database!"
end

def drop_tables(db)
  db.execute('DROP TABLE IF EXISTS rocks')
end

def create_tables(db)
  db.execute('CREATE TABLE rocks (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL, 
              description TEXT,
              rock_type TEXT,
              owner_id INTEGER,
              img TEXT,
              publicness TEXT)')
end

def populate_tables(db)
  db.execute('INSERT INTO rocks (name, description, rock_type, owner_id, img, publicness) VALUES ("test rock", "This is a test rock", "Grianite", 1, "definetly an image", "true")')
end


seed!(rocks)

users = SQLite3::Database.new("users.db")


def seed2!(db)
  puts "Using db file: db/todos.db"
  puts "🧹 Dropping old tables..."
  drop_tables2(db)
  puts "🧱 Creating tables..."
  create_tables2(db)
  puts "🍎 Populating tables..."
  populate_tables2(db)
  puts "✅ Done seeding the database!"
end

def drop_tables2(db)
  db.execute('DROP TABLE IF EXISTS users')
  db.execute('DROP TABLE IF EXISTS rocks')
end

def create_tables2(db)
  db.execute('CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT NOT NULL, 
              password TEXT NOT NULL,
              adminstatus TEXT,
              geologstatus TEXT)')
end

def populate_tables2(db)
  password = BCrypt::Password.create("12345")
  db.execute('INSERT INTO users (username, password, adminstatus, geologstatus) VALUES ("Admin", ?, "true", "true")', [password])
end


seed2!(users)

