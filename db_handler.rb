require 'sqlite3'
require_relative 'model/student.rb'

class DbHandler 

    attr_reader :db

    def initialize
        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true
    end

    def get_by_id(user_id)
        user = @db.execute("SELECT student_id, username, password_hash
            FROM students 
            WHERE student_id = ?", 
            user_id).first

        unless user
            return false
        end

        id = user["student_id"].to_i
        username = user["username"].to_s
        password_hashed = user["password_hash"].to_s

        #todo: check if student or teacher: if user["is_student"] 
        #      and create Student or Teacher objects

        return new Student(id, username, password_hashed, nil)
    end

    def login(username, password_nothashed)
        user = @db.execute("SELECT student_id, username, password_hash
            FROM students 
            WHERE username = ?", 
            username).first
        
        unless user
            return false
        end

        id = user["student_id"].to_i
        username = user["username"].to_s
        db_password_hashed = user["password_hash"].to_s
        
        password_hash = BCrypt::Password.new(db_password_hashed)

        if password_hash == password_nothashed
            return new Student(id, username, password_hash, nil)
        end
    end


# todo: check to not initialize it if initialized
#    def self.db 
#        return @db if @db
#
#        @db = SQLite3::Database.new("db/app.sqlite")
#        @db.results_as_hash = true#
#
#        return @db
#    end


end