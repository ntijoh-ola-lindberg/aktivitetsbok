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

        if request.get? && request.path != "/login" && session[:user_id].nil?
            redirect '/login'
        else
            @current_user = @login_handler.get_user_by_id(session[:user_id])
            @activities = Activity.get_all_activities_for_userid(@db_handler, session[:user_id])
        end

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
            flash[:failedlogin_anv_losenord] = "Inloggningen misslyckades. Lösenord och / eller användarnamn är ej rätt."
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
        
        @log_id = params["logid"].to_i

        slim :activity        
    end

    post '/activity/log' do
        done = params["done"].to_s
        learned = params["learned"].to_s
        understood = params["understood"].to_s
        more = params["more"].to_s

        a = Activity.new(@db_handler, @current_user.id, nil, nil, nil, done, learned, understood, more, nil)
        a.log_activity()

        flash[:saved] = "Aktiviteten sparades"
        redirect back
    end

    post '/activity/edit/:id' do
        edit_log_id = params[:id].to_i
        done_updated = params["done"].to_s
        learned_updated = params["learned"].to_s
        understood_updated = params["understood"].to_s
        more_updated = params["more"].to_s

        @actv = @activities.detect { |a| a.activity_id == edit_log_id }
        @actv.update_activity(done_updated, learned_updated, understood_updated, more_updated)

        flash[:saved] = "Aktiviteten uppdaterades"
        redirect '/'
    end

    post '/activity/delete/:id' do
        delete_log_id = params[:id].to_i
        actv = @activities.detect { |a| a.activity_id == delete_log_id }
        actv.delete_activity()

        flash[:deleted_activity] = "Aktiviteten togs bort"
        redirect '/'
    end

end