require 'sqlite3'

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
              img TEXT)')
end

def populate_tables(db)
  db.execute('INSERT INTO rocks (name, description, rock_type, owner_id, img) VALUES ("test rock", "This is a test rock", "grianite", 1, "definetly an image")')
end


seed!(rocks)





