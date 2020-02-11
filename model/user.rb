require_relative '../db_handler.rb'

class User

    attr_reader :id, :username, :password_hashed

    def initialize(user_id, username, password_hashed, dbhandler) 
        @dbhandler = dbhandler

        @id = user_id
        @username = username
        @password_hashed = password_hashed
    end

end