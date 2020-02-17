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

        #todo: replace with crud pattern - now using @log_id to know what activity to edit / delete
        @log_id = params["logid"].to_i

        if(params.has_key?(:deleteactivity) && @log_id > 0 ) #delete post
            Activity.delete_activity(@db_handler, @log_id)
            flash[:deleted_activity] = "Aktiviteten togs bort"
            redirect '/'
        end

        slim :activity        
    end

    post '/log-work' do
        log_done = params["log-done"].to_s
        log_learned = params["log-learned"].to_s
        log_understood = params["log-understood"].to_s
        log_more = params["log-more"].to_s

        a = Activity.new(@db_handler, @current_user.id, nil, nil, nil, log_done, log_learned, log_understood, log_more, nil)
        a.log_activity()

        flash[:saved] = "Aktiviteten sparades"
        redirect back
    end

    post '/update-log-work' do
        edit_log_id = params["edit-log-id"].to_i
        done_updated = params["log-done"].to_s
        learned_updated = params["log-learned"].to_s
        understood_updated = params["log-understood"].to_s
        more_updated = params["log-more"].to_s

        #todo: tried to use detect but couldnt
        #@activity = @activities.detect { |a| a.activity_id = edit_log_id }

        #todo: move to general find method - will need exactly the same for delete
        @activities.each do |act|
            if(act.activity_id == edit_log_id)
                act.update_activity(done_updated, learned_updated, understood_updated, more_updated)
                flash[:saved] = "Aktiviteten uppdaterades"
            end
        end

        flash[:saved] = "Ingen aktivitet uppdaterades"
        redirect '/'
    end

end