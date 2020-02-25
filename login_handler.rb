require_relative 'model/student.rb'
require_relative 'model/teacher.rb'
require_relative 'db_handler.rb'

class LoginHandler 

    def initialize(db_handler)
        @db_handler = db_handler
    end

    def get_user_by_id(user_id)
        user = @db_handler.db.execute("SELECT * 
            FROM users 
            WHERE id = ?", 
            user_id).first
        unless user
            return false
        end

        id = user["id"].to_i
        username = user["username"].to_s
        password_hashed = user["password_hash"].to_s
        role = user["role"].to_i

        return get_role(role, id, username, password_hashed)
    end

    def login(username, password_nothashed)
        user = @db_handler.db.execute("SELECT *
            FROM users 
            WHERE username = ?", 
            username).first
        
        unless user
            return false
        end

        id = user["id"].to_i
        username = user["username"].to_s
        db_password_hashed = user["password_hash"].to_s
        role = user["role"].to_i
        
        password_hash = BCrypt::Password.new(db_password_hashed)

        if password_hash == password_nothashed
            return get_role(role, id, username, password_hash)
        end
    end


    # roles
    # 1 = teacher
    # 2 = studend
    def get_role(role, id, username, password_hash)
        if role == 1
            return Teacher.new(id, username, password_hash, @db_handler)
        elseif role == 2
            return Student.new(id, username, password_hash, @db_handler)
        else 
            return false
        end        
    end

end