require 'sqlite3'
require 'date'

class Activity 
    
    attr_reader :all_activity

    def initialize (userid)
        @userid = userid
        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true

        @all_activity = @db.execute("SELECT log_id, student_id, username, log_date, done, learned, understood, more, updated_date
                                     FROM students 
                                     INNER JOIN activities ON students.student_id = activities.log_student 
                                     WHERE student_id = ?
                                     ORDER BY log_date DESC", @userid)
    end

    def get_username 
        return @all_activity.first["username"]
    end

    def log_activity(log_done, log_learned, log_understood, log_more, log_updated_date)
        @db.execute("INSERT INTO activities 
                            (log_student, 
                             done, 
                             learned, 
                             understood, 
                             more) 
            VALUES (?, ?, ?, ?, ?)", 
            @userid, log_done, log_learned, log_understood, log_more);
    end

    def update_activity(edit_log_id, log_done, log_learned, log_understood, log_more)
        t = DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d %H:%M:%S")
        @db.execute("UPDATE activities
                     SET done = ?,
                         learned = ?,
                         understood = ?,
                         more = ?,
                         updated_date = ?
                     WHERE log_id = ?",
                     log_done, log_learned, log_understood, log_more, t, edit_log_id);
    end

    def delete_activity(log_id)
        p log_id 
        @db.execute("DELETE FROM activities
                     WHERE log_id = ?", log_id);
    end
end