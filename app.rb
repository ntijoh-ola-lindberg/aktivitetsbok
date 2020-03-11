require 'byebug'
require 'rack-flash'
require "sinatra"
require "sinatra/base"
require "sinatra/namespace"

require_relative 'db_handler.rb'
require_relative 'login_handler.rb'
require_relative 'model/hi.rb'
require_relative 'model/activity.rb'
require_relative 'model/student.rb'
require_relative 'model/group.rb'

class App < Sinatra::Base
    register Sinatra::Namespace

    enable :sessions
    use Rack::Flash

    before do
        @db_handler = DbHandler.new 
        @login_handler = LoginHandler.new(@db_handler) 

        session[:user_id] = 1 #todo: remove - disables login system for dev

        if request.get? && request.path != "/login" && session[:user_id].nil? 
            redirect '/login'
        else

            #@current_user = @login_handler.get_user_by_id(session[:user_id])
            @current_user = @login_handler.get_user_by_id(session[:user_id])
            @activities = Activity.get_all_activities_for_userid(@db_handler, session[:user_id])

            @greeting = Hi.get_random_greeting
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
        cookies.delete('user_id')
        flash[:loggedout] = "Du är utloggad"
        redirect '/'
    end

    get '/' do
        @log_id = params["logid"].to_i

        slim :activity        
    end

    namespace '/activity' do

        post '/log' do
            done = params["done"].to_s
            learned = params["learned"].to_s
            understood = params["understood"].to_s
            more = params["more"].to_s

            a = Activity.new(@db_handler, @current_user.id, nil, nil, nil, done, learned, understood, more, nil)
            a.log_activity()

            flash[:saved] = "Aktiviteten sparades"
            redirect back
        end

        post '/edit/:id' do
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

        post '/delete/:id' do
            delete_log_id = params[:id].to_i
            actv = @activities.detect { |a| a.activity_id == delete_log_id }
            actv.delete_activity()

            flash[:deleted_activity] = "Aktiviteten togs bort"
            redirect '/'
        end

    end

    namespace '/admin' do

        before do

            unless @current_user.is_teacher
                flash[:permission_denied] = 'Användaren är inte lärare: #{@current_user.username}'
                redirect '/'
            end

            @groups = Group.get_all_groups(@db_handler)
        end

        get '/?' do
            slim :admin
        end

        post '/:id/new-student/?' do
            group_id = params[:id]
            new_user_email = params['new-user-email']
            new_user_password = params['new-user-password']
            new_user_hashed_password = @login_handler.hash_password(new_user_password)

            new_user = User.new(@db_handler, nil, new_user_email, new_user_hashed_password, false)

            current_group = @groups.detect{ | cg | cg.id.to_i == group_id.to_i }

            current_group.add_user(new_user, false)

            redirect '/admin'
        end

    end

end