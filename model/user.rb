require_relative '../db_handler.rb'

class User

    attr_reader :id, :username, :password_hashed, :is_teacher

    def initialize(user_id, username, password_hashed, dbhandler, is_teacher) 
        @dbhandler = dbhandler

        @id = user_id
        @username = username
        @password_hashed = password_hashed
        @is_teacher = is_teacher
    end

    def to_s
        "id: '#{@id}', username: '#{@username}', is_teacher: '#{@is_teacher}'"
    end

    # roles
    # 1 = teacher
    # 2 = studend
    def self.get_user(global_role, id, username, password_hash)

        if global_role == 1
            return Teacher.new(id, username, password_hash, @db_handler, true)
        elsif global_role == 2
            return Student.new(id, username, password_hash, @db_handler, false)
        else 
            return false
        end        
    end

end