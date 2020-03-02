require './model/anvandare.rb'
require './model/student.rb'
require './model/larare.rb'
require './model/klass.rb'
require './model/logg.rb'

# Exempelkod. Pseudo-kod. Ej tänkt att köras.
class AppController < Sinatra::Base

    before do
        @anvandare = Anvandare.logga_in( 1, 'aoe' )
    end

    get '/' do
        #TODO: redirect to student if we are a student and teacher if teacher
    end

    # Hämtar elevens loggar från databasen och visar i vyn
    get '/student' do
        @loggar = @anvandare.loggar

        slim :student
    end

    # Läser fyra fält från vyn, 
    # spara till databasen
    # redirectar till studentents förstasida
    post '/student/skriv_logg' do 
        gjort = params['gjort'].to_s
        lart = params['lart'].to_s
        forstatt = params['forstatt'].to_s
        mer = params['mer'].to_s

        logg = Logg.new( gjort, lart, forstatt, mer )
        @anvandare.skriv(logg)

        redirect '/student'
    end

    # Hämtar lärarens klasser från databasen och visar i vyn
    get '/larare' do
        @klasser = @anvandare.klasser

        slim :larare
    end

    # Läser tre fält från vyn, 
    # skapar en ny student och en ny klass, 
    # lägger till studenten i klassen och
    # redirectar till lärarens förstasida
    post '/larare/registrera_student' do
        anvandar_namn = params['anvandarnamn'].to_s
        losenord_text = params['losenord'].to_s
        klass_namn = params['klass'].to_s

        student = Student.new ( anvandar_namn, losenord_text )
        @anvandare.registrera ( student )
        klass = Klass.new ( klass_namn )
        lägg_till ( student, klass )

        redirect '/larare'
    end

end