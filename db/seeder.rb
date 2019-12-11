class Seeder

    def self.seed!
       drop_tables 
       create_tables
       populate_users
    end

    private 

    def self.db 
        @db ||= SQLite3::Database.new("db/app.sqlite")
    end

    def self.drop_tables
        db.execute("DROP TABLE IF EXISTS users");
    end

    def self.create_tables
        db.execute("CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username VARCHAR(255) NOT NULL UNIQUE,
            password_hash VARCHAR(255) NOT NULL )
        ");
    end

    def self.populate_users 
        users = [
            {username: "grill@korv.com", password_hash: BCrypt::Password.create("123")},
            {username: "banan@paj.com", password_hash: BCrypt::Password.create("123")}
          ]
      
          users.each do |user|
            db.execute("INSERT INTO users (username, password_hash) VALUES (?,?)", user[:username], user[:password_hash])
          end
    end
end
