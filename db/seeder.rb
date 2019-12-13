class Seeder

    def self.seed!
       drop_tables 
       create_tables
       populate_users
       populate_logs
    end

    private 

    def self.db 
        @db ||= SQLite3::Database.new("db/app.sqlite")
    end

    def self.drop_tables
        db.execute("DROP TABLE IF EXISTS students");
        db.execute("DROP TABLE IF EXISTS logs")
    end

    def self.create_tables
        db.execute("CREATE TABLE students (
            student_id INTEGER PRIMARY KEY AUTOINCREMENT,
            username VARCHAR(255) NOT NULL UNIQUE,
            password_hash VARCHAR(255) NOT NULL 
            )
        ");

        db.execute("
            CREATE TABLE logs (
                log_id INTEGER PRIMARY KEY AUTOINCREMENT,
                log_student INTEGER,
                log_date TEXT DEFAULT CURRENT_TIMESTAMP,
                done TEXT NOT NULL,
                learned TEXT NOT NULL,
                understood TEXT NOT NULL,
                more TEXT NOT NULL,
                FOREIGN KEY(log_student) REFERENCES students(student_id)
            )
        ")
    end

    def self.populate_users 
        users = [
            {username: "apple@frukt.se", password_hash: BCrypt::Password.create("123")},
            {username: "banan@frukt.se", password_hash: BCrypt::Password.create("123")},
            {username: "citron@frukt.se", password_hash: BCrypt::Password.create("123")},
            {username: "daddel@frukt.se", password_hash: BCrypt::Password.create("123")}
          ]
      
          users.each do |user|
            db.execute("INSERT INTO students (username, password_hash) VALUES (?,?)", user[:username], user[:password_hash])
          end
    end

    def self.populate_logs
        logs = [
            {student_id: "1", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något"},
            {student_id: "2", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något"},
            {student_id: "3", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något"},
            {student_id: "4", done: "Jag gjorde något", learned: "Jag lärde mig något", understood: "Jag förstod något", more: "Jag vill lära mig med om något"},
        ]

        logs.each do |log|
            db.execute("INSERT INTO logs (log_student, done, learned, understood, more) VALUES (?,?,?,?,?)", 
                log[:student_id], log[:done], log[:learned], log[:understood], log[:more]);
        end
    end
end
