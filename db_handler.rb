require 'sqlite3'

class DbHandler 

    attr_reader :db

    def initialize
        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true
    end
end