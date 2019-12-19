require 'byebug'
require 'rack-flash'
require './model/hi.rb'
require './model/activity.rb'

class App < Sinatra::Base

    enable :sessions
    use Rack::Flash
    @activity
    @@userid = 1
    
    before do
        @activity = Activity.new(@@userid)
    end

    get '/' do
        
        @greeting = Hi.new.get_random_greeting
        @log = @activity.get_activity

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

end