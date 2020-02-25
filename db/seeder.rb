class Seeder

    def self.seed!
       drop_tables 
       create_tables
       populate_users
       populate_activities
    end

    private 

    def self.db 
        @db ||= SQLite3::Database.new("db/app.sqlite")
    end

    def self.drop_tables
        db.execute("DROP TABLE IF EXISTS users")
        db.execute("DROP TABLE IF EXISTS activities")
    end

    def self.create_tables
        db.execute("CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username VARCHAR(255) NOT NULL UNIQUE,
            password_hash VARCHAR(255) NOT NULL,
            role INTEGER NOT NULL 
            )
        ");

        db.execute("
            CREATE TABLE activities (
                log_id INTEGER PRIMARY KEY AUTOINCREMENT,
                log_student INTEGER,
                log_date TEXT DEFAULT CURRENT_TIMESTAMP,
                done TEXT NOT NULL,
                learned TEXT NOT NULL,
                understood TEXT NOT NULL,
                more TEXT NOT NULL,
                updated_date TEXT,
                FOREIGN KEY(log_student) REFERENCES users(id)
            )
        ")
    end

    def self.populate_users 
        users = [
            {username: "apple@frukt.se", password_hash: BCrypt::Password.create("123"), role: 1},
            {username: "banan@frukt.se", password_hash: BCrypt::Password.create("123"), role: 2},
            {username: "citron@frukt.se", password_hash: BCrypt::Password.create("123"), role: 2},
            {username: "daddel@frukt.se", password_hash: BCrypt::Password.create("123"), role: 2}
          ]
      
          users.each do |user|
            db.execute("INSERT INTO users (username, password_hash, role) VALUES (?,?,?)", user[:username], user[:password_hash], user[:role])
          end
    end

    def self.populate_activities
        activities = [
            {user_id: "1", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något", updated_date: "2021-01-01 01:01:01"},
            {user_id: "2", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något", updated_date: "2022-01-01 01:01:01"},
            {user_id: "3", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något", updated_date: "2023-01-01 01:01:01"},
            {user_id: "4", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något", updated_date: "2024-01-01 01:01:01"}
        ]

        activities.each do |activity|
            db.execute("INSERT INTO activities (log_student, done, learned, understood, more, updated_date) VALUES (?,?,?,?,?,?)", 
                activity[:user_id], activity[:done], activity[:learned], activity[:understood], activity[:more], activity[:updated_date]);
        end
    end
end
