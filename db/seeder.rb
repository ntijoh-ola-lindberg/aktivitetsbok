class Seeder

    #Browse SQL-file with https://sqlitebrowser.org

    def self.seed!
       drop_tables 
       create_tables
       populate_users
       populate_activities
       populate_groups
    end

    private 

    def self.db 
        @db ||= SQLite3::Database.new("db/app.sqlite")
    end

    def self.drop_tables
        db.execute("DROP TABLE IF EXISTS users")
        db.execute("DROP TABLE IF EXISTS activities")
        db.execute("DROP TABLE IF EXISTS groups")
        db.execute("DROP TABLE IF EXISTS groups_users")
    end

    def self.create_tables
        db.execute("CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username VARCHAR(255) NOT NULL UNIQUE,
            password_hash VARCHAR(255) NOT NULL,
            global_role INTEGER NOT NULL 
            )
        ");

        db.execute("
            CREATE TABLE activities (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER,
                date TEXT DEFAULT CURRENT_TIMESTAMP,
                date_updated TEXT,
                done TEXT NOT NULL,
                learned TEXT NOT NULL,
                understood TEXT NOT NULL,
                more TEXT NOT NULL,
                FOREIGN KEY(user_id) REFERENCES users(id)
            )
        ")

        db.execute("
            CREATE TABLE groups (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                date_created TEXT DEFAULT CURRENT_TIMESTAMP
            )
        ")

        db.execute("
            CREATE TABLE groups_users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                group_id INTEGER NOT NULL,
                user_id INTEGER NOT NULL,
                group_role INTEGER NOT NULL
            )
        ")
    end

    def self.populate_users 
        # roles
        # 1 = teacher
        # 2 = studend
        users = [
            {username: "apple@frukt.se", password_hash: BCrypt::Password.create("123"), global_role: 1},
            {username: "banan@frukt.se", password_hash: BCrypt::Password.create("123"), global_role: 2},
            {username: "citron@frukt.se", password_hash: BCrypt::Password.create("123"), global_role: 2},
            {username: "daddel@frukt.se", password_hash: BCrypt::Password.create("123"), global_role: 2},
            {username: "morot@gronsak.se", password_hash: BCrypt::Password.create("123"), global_role: 1},
            {username: "gurka@gronsak.se", password_hash: BCrypt::Password.create("123"), global_role: 2},
            {username: "tomat@gronsak.se", password_hash: BCrypt::Password.create("123"), global_role: 2},
            {username: "sallat@gronsak.se", password_hash: BCrypt::Password.create("123"), global_role: 2}
          ]
      
        users.each do |user|
            db.execute("INSERT INTO users (username, password_hash, global_role) VALUES (?,?,?)", user[:username], user[:password_hash], user[:global_role])
        end
    end

    def self.populate_activities
        activities = [
            {user_id: "1", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något", date_updated: "2021-01-01 01:01:01"},
            {user_id: "2", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något", date_updated: "2022-01-01 01:01:01"},
            {user_id: "3", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något", date_updated: "2023-01-01 01:01:01"},
            {user_id: "4", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något", date_updated: "2024-01-01 01:01:01"}
        ]

        activities.each do |activity|
            db.execute("INSERT INTO activities (user_id, done, learned, understood, more, date_updated) VALUES (?,?,?,?,?,?)", 
                activity[:user_id], activity[:done], activity[:learned], activity[:understood], activity[:more], activity[:date_updated]);
        end
    end

    def self.populate_groups
        
        groups = [
            {name: "Spanska 1 - 1a"},
            {name: "Tyska 2 - 2b"},
            {name: "Franska 2 - 2b"}
        ]

        groups.each do |g|
            db.execute("INSERT INTO groups (name) VALUES (?)", g[:name])
        end

        groups_users = [
            {group_id: 1, user_id: 1, group_role: 1},
            {group_id: 1, user_id: 2, group_role: 2},
            {group_id: 1, user_id: 3, group_role: 2},
            {group_id: 1, user_id: 4, group_role: 2},
            {group_id: 2, user_id: 5, group_role: 1},
            {group_id: 2, user_id: 6, group_role: 2},
            {group_id: 2, user_id: 7, group_role: 2},
            {group_id: 2, user_id: 8, group_role: 2},
            {group_id: 1, user_id: 6, group_role: 2},
        ]

        groups_users.each do |gu|
            db.execute("INSERT INTO groups_users (group_id, user_id, group_role) VALUES (?,?,?)", gu[:group_id], gu[:user_id], gu[:group_role])
        end
    end
end
