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
                content TEXT NOT NULL,
                FOREIGN KEY(log_student) REFERENCES students(student_id)
            )
        ")
    end

    def self.populate_users 
        users = [
            {username: "grill@korv.com", password_hash: BCrypt::Password.create("123")},
            {username: "banan@paj.com", password_hash: BCrypt::Password.create("123")},
            {username: "apple@paj.com", password_hash: BCrypt::Password.create("123")}
          ]
      
          users.each do |user|
            db.execute("INSERT INTO students (username, password_hash) VALUES (?,?)", user[:username], user[:password_hash])
          end
    end

    def self.populate_logs
        logs = [
            {student_id: "1" ,content: "Student 1 gjorde något"},
            {student_id: "2" ,content: "Student 2 gjorde något"},
            {student_id: "3" ,content: "Student 3 gjorde något"}
        ]

        logs.each do |log|
            db.execute("INSERT INTO logs (log_student, content) VALUES (?,?)", log[:student_id], log[:content]);
        end
    end
end
