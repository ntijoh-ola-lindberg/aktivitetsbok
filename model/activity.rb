require 'sqlite3'

class Activity 
    
    attr_reader :all_activity

    def initialize (userid)
        @userid = userid
        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true

        @all_activity = @db.execute("SELECT log_id, student_id, username, log_date, done, learned, understood, more
            FROM students 
            INNER JOIN activities ON students.student_id = activities.log_student 
            WHERE student_id = ?
            ORDER BY log_date DESC", @userid)
    end

    def get_username 
        return @all_activity.first["username"]
    end

    def log_activity(log_done, log_learned, log_understood, log_more)
        @db.execute("INSERT INTO activities 
            (log_student, done, learned, understood, more) 
            VALUES (?, ?, ?, ?, ?)", 
            @userid, log_done, log_learned, log_understood, log_more);
    end
end