require_relative 'model/student.rb'
require_relative 'db_handler.rb'

class LoginHandler 

    def initialize(db_handler)
        @db_handler = db_handler
    end

    def get_user_by_id(user_id)
        user = @db_handler.db.execute("SELECT student_id, username, password_hash
            FROM students 
            WHERE student_id = ?", 
            user_id).first

        unless user
            return false
        end

        id = user["student_id"].to_i
        username = user["username"].to_s
        password_hashed = user["password_hash"].to_s

        # todo: check if student or teacher: if user["is_student"] 
        #       and create Student or Teacher objects

        return Student.new(id, username, password_hashed, @db_handler)
    end

    def login(username, password_nothashed)
        user = @db_handler.db.execute("SELECT student_id, username, password_hash
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
            # todo: check if student or teacher: if user["is_student"] 
            #       and create Student or Teacher objects
            return Student.new(id, username, password_hash, @db_handler)
        end
    end

end