require 'byebug'
require 'rack-flash'
require './model/hi.rb'
require './model/activity.rb'
require './model/student.rb'

class App < Sinatra::Base

    enable :sessions
    use Rack::Flash

    before do

        @current_user = Student.get_by_id(session[:studentid])
        @activity = Activity.new(session[:studentid])
   
        if request.get? && request.path != "/login"
            unless @current_user
                redirect '/login'
            end
        end
    end

    get '/' do
        @greeting = Hi.new.get_random_greeting
        @log = @activity.get_activity

        slim :activity        
    end

    get '/login' do
        slim :login
    end

    post '/do-login' do
        username = params["username"].to_s
        password_nothashed = params["password"].to_s

        student = Student.login(username, password_nothashed)
        
        if student
            session[:studentid] = student.id
            
            redirect '/'
        else
            redirect '/login'
        end
    end

    post '/log-work' do
        @log_done = params["log-done"].to_s
        @log_learned = params["log-learned"].to_s
        @log_understood = params["log-understood"].to_s
        @log_more = params["log-more"].to_s

        @activity.log_activity(@log_done, @log_learned, @log_understood, @log_more)

        flash[:saved] = "Aktiviteten sparades"
        redirect back
    end

end