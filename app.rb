class App < Sinatra::Base

    before do 
        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true
        return @db
    end

    get '/' do
        @greeting = "Hello world"
        @users = @db.execute("SELECT * FROM USERS")

        slim :greeting        
    end

end