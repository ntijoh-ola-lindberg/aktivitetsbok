require 'byebug'
require 'rack-flash'
require_relative 'db_handler.rb'
require_relative 'login_handler.rb'
require_relative 'model/hi.rb'
require_relative 'model/activity.rb'
require_relative 'model/student.rb'

class App < Sinatra::Base

    enable :sessions
    use Rack::Flash

    before do
        @db_handler = DbHandler.new 
        @login_handler = LoginHandler.new(@db_handler)

        @current_user = @login_handler.get_by_id(session[:user_id])

        if request.get? && request.path != "/login" && !@current_user
            redirect '/login'
        end

        #@activity = Activity.new(@db_handler, session[:user_id])

       @activities = Activity.activity_factory(@db_handler, session[:user_id])

    end

    get '/login' do
        slim :login
    end

    post '/do-login' do
        username = params["username"].to_s
        password_nothashed = params["password"].to_s

        user =  @login_handler.login(username, password_nothashed)

        if user
            session[:user_id] = user.id
            redirect '/'
        else
            redirect '/login'
        end
    end
    
    get '/logout' do
        session.clear
        flash[:loggedout] = "Du är utloggad"
        redirect '/'
    end

    get '/' do
        @greeting = Hi.get_random_greeting
        
        #@log = @activity.all_activity

        @log_id = params["logid"].to_i

        if(params.has_key?(:editactivity) && @log_id > 0 ) #edit post
            @log_id = params["logid"].to_i
        end

        if(params.has_key?(:deleteactivity) && @log_id > 0 ) #delete post
            @log_id = params["logid"].to_i
            @activity.delete_activity(@log_id)
            flash[:deleted_activity] = "Aktiviteten togs bort"
            redirect '/'
        end

        slim :activity        
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

    post '/update-log-work' do
        @edit_log_id = params["edit-log-id"].to_i
        @log_done = params["log-done"].to_s
        @log_learned = params["log-learned"].to_s
        @log_understood = params["log-understood"].to_s
        @log_more = params["log-more"].to_s

        @activity.update_activity(@edit_log_id, @log_done, @log_learned, @log_understood, @log_more)

        flash[:saved] = "Aktiviteten uppdaterades"
        redirect '/'
    end

end