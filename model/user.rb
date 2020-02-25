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

end