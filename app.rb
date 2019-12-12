class App < Sinatra::Base

    before do 
        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true
        return @db
    end

    get '/' do
        @dataset = @db.execute("SELECT student_id, username, log_date, content 
                                FROM students 
                                INNER JOIN logs ON students.student_id = logs.log_student 
                                WHERE student_id = 1
                                ORDER BY log_date DESC")

        @username = @dataset.first["username"]
        
        if params["status"] == "saved"
            @status = "Aktiviteten sparades"
        end

        
        slim :greeting        
    end

    post '/log-work' do
        @log_content = params["log-content"].to_s
        @db.execute("INSERT INTO logs (log_student, content) VALUES (?,?)", 1, @log_content);

        redirect "/?status=saved"
    end

end