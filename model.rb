
def connect_db()
  db = SQLite3::Database.new("db/db.db")
  db.results_as_hash = true
  return db
end

def personal_rockage(db, owner_id)
  return db.execute("SELECT * FROM rocks WHERE owner_id = ? ORDER BY id DESC", [owner_id])
end

def new_shiny_rock(db, new_rock, description, rock_type, owner_id, image, publicness)
  return db.execute("INSERT INTO rocks (name, description, rock_type, owner_id, img, publicness) VALUES (?, ?, ?, ?, ?, ?) ", [new_rock, description, rock_type, owner_id, image, publicness])
end

def delete_rock(db, removing)
  return db.execute("DELETE FROM rocks WHERE id = ?", removing)
end

def select_rock(db, id)
  return db.execute("SELECT * FROM rocks WHERE id=?", id).first
end

def update_rock(db, name, description, rock_type, image, publicness, id)
  return db.execute("UPDATE rocks SET name=?, description=?, rock_type=?, img=?, publicness=? WHERE id=?", [name, description, rock_type, image, publicness, id])
end

def select_user(db, username)
  return db.execute("SELECT id FROM users WHERE username=?", username)
end

def add_user(db, username, password_digest, geologstatus)
  return db.execute("INSERT INTO users(username, password, adminstatus, geologstatus) VALUES(?,?, 0, ?)", [username, password_digest, geologstatus])
end

def select_password_of_user(db, username)
  return db.execute("SELECT id, password FROM users WHERE username=?", username)
end

def select_public_rocks(db)
  return db.execute("SELECT * FROM rocks WHERE publicness = 'true' ORDER BY id DESC")
end

def find_adminness(db, user_id)
  return db.execute("SELECT adminstatus FROM users WHERE id = ?", user_id) 
end

def select_personal_boxes(db, user_id)
  return db.execute("SELECT * FROM boxes WHERE owner_id = ? ORDER BY id DESC", user_id)
end

def find_boxinfo(db, id)
  return db.execute("SELECT * FROM boxes WHERE id = ?", [id]).first
end

def find_internal_rocks(db, id, user_id)
  return db.execute("SELECT * FROM rel_box_rocks INNER JOIN rocks ON rel_box_rocks.rock_id = rocks.id WHERE box_id = ? AND owner_id = ?", [id, user_id])
end

def delete_from_boxes(db, removingage, removing)
  return db.execute("DELETE FROM rel_box_rocks WHERE rock_id = ? AND box_id = ?",[removingage, removing])
end

def create_new_box(db, new_box, description, user_id, publicness)
  return db.execute("INSERT INTO boxes (name, description, owner_id, publicness) VALUES ( ?, ?, ?, ?) ", [new_box, description, user_id, publicness])
end

def select_public_or_owned_rocks(db, user_id)
  return db.execute("SELECT * FROM rocks WHERE publicness = 'true' OR owner_id= ? ORDER BY id DESC", [user_id])
end