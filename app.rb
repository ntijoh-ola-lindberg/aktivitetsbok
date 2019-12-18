require 'byebug'
require 'rack-flash'

class App < Sinatra::Base

    enable :sessions
	use Rack::Flash

    before do 
        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true
        return @db
    end

    get '/' do
        @dataset = @db.execute("SELECT student_id, username, log_date, done, learned, understood, more
                                FROM students 
                                INNER JOIN logs ON students.student_id = logs.log_student 
                                WHERE student_id = ?
                                ORDER BY log_date DESC", 1)

                                #log[:student_id], log[:done], log[:learned], log[:understood], log[:more]);

        #byebug

        @username = @dataset.first["username"]
        
        #if params["status"] == "saved"
        #    @status = "Aktiviteten sparades"
        #end

        
        slim :greeting        
    end

    post '/log-work' do
        @log_done = params["log-done"].to_s
        @log_learned = params["log-learned"].to_s
        @log_understood = params["log-understood"].to_s
        @log_more = params["log-more"].to_s
        @db.execute("INSERT INTO logs (log_student, done, learned, understood, more) VALUES (?, ?, ?, ?, ?)", 1, @log_done, @log_learned, @log_understood, @log_more);

        #redirect "/?status=saved"
        #todo: flash
        flash[:saved] = "Aktiviteten sparades"
        redirect back
    end

end