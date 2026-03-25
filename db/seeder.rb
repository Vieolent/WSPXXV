require 'sqlite3'
require 'bcrypt'


db = SQLite3::Database.new("db.db")


def seed4!(db)
  puts "Using db file: db/todos.db"
  puts "🧹 Dropping old tables..."
  drop_tables4(db)
  puts "🧱 Creating tables..."
  create_tables4(db)
  puts "🍎 Populating tables..."
  populate_tables4(db)
  puts "✅ Done seeding the database!"
end

def drop_tables4(db)
  db.execute('DROP TABLE IF EXISTS users')
  db.execute('DROP TABLE IF EXISTS rocks')
  db.execute('DROP TABLE IF EXISTS boxes')
  db.execute('DROP TABLE IF EXISTS rel_box_rocks')
end

def create_tables4(db)
  db.execute('CREATE TABLE rel_box_rocks (
              rock_id INTEGER, 
              box_id INTEGER,
              PRIMARY KEY (rock_id, box_id),
              FOREIGN KEY (rock_id) REFERENCES Rocks(id)
                  ON DELETE CASCADE,
              FOREIGN KEY (box_id) REFERENCES Boxes(id)
                  ON DELETE CASCADE)')

  db.execute('CREATE TABLE rocks (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL, 
              description TEXT,
              rock_type TEXT,
              owner_id INTEGER,
              img TEXT,
              publicness TEXT)')

  db.execute('CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT NOT NULL, 
              password TEXT NOT NULL,
              adminstatus TEXT,
              geologstatus TEXT)')

  db.execute('CREATE TABLE boxes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL, 
              description TEXT,
              publicness TEXT,
              owner_id INTEGER)')

end

def populate_tables4(db)
  db.execute('INSERT INTO rocks (name, description, rock_type, owner_id, img, publicness) VALUES ("test rock", "This is a test rock", "Grianite", 1, "definetly an image", "true")')
  db.execute('INSERT INTO rel_box_rocks (rock_id, box_id) VALUES (1, 1)')
  password = BCrypt::Password.create("12345")
  db.execute('INSERT INTO users (username, password, adminstatus, geologstatus) VALUES ("Admin", ?, "true", "true")', [password])
  db.execute('INSERT INTO boxes (name, description, publicness, owner_id) VALUES ("Testbox", "This is the default box", "true", 1)')
end

seed4!(db)