require 'sqlite3'
require 'byebug'

class Student

    attr_reader :id, :username, :password_hashed

    def initialize(dbhash)
        @id = dbhash["student_id"].to_i
        @username = dbhash["username"].to_s
        @password_hashed = dbhash["password_hash"].to_s
    end

    def self.db 
        return @db if @db

        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true

        return @db
    end

    def self.get_by_id(student_id)
        student = db.execute("SELECT student_id, username, password_hash
            FROM students 
            WHERE student_id = ?", 
            student_id).first
        
        if student
            return new(student)
        end

        return false
    end

    def self.login(username, password_nothashed)
        student = db.execute("SELECT student_id, username, password_hash
            FROM students 
            WHERE username = ?", 
            username).first

        unless student
            return false
        end
        
        password_hash = BCrypt::Password.new(student["password_hash"])

        if password_hash == password_nothashed
            return new(student)
        end

        return false
    end

end