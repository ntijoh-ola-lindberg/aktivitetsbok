class Hi 

    def get_random_greeting
        
        @greetings = [
            "Hej",
            "Hi",
            "Bonjour",
            "Hola",
            "Hallo",
            "Ciao",
            "Olà",
            "Namaste",
            "Salaam",
            "Zdras-tvuy-te",
            "Konnichiwa",
            "Ahn-young-ha-se-yo",
            "Merhaba",
            "Sain bainuu",
            "Szia",
            "Marhaba",
            "Sannu",
            "Jambo",
            "Ni hau",
            "Nay noh",
            "Halo"]

        return @greetings[rand(@greetings.length)]
    end
    
end