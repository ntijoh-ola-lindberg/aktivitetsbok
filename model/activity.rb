require 'date'
require_relative '../db_handler.rb'

class Activity
        
    attr_reader :all_activity, :user_id, :activity_id, :username, :date, :done, :learned, :understood, :more, :updated_date

    def initialize (dbhandler, userid, log_id=nil, username=nil, log_date=nil, done=nil, learned=nil, understood=nil, more=nil, updated_date=nil)
        @dbhandler = dbhandler 

        @user_id = userid
        @activity_id = log_id
        @username = username
        @date = log_date
        @done = done
        @learned = learned
        @understood = understood
        @more = more
        @updated_date = updated_date

        @all_activity = @dbhandler.db.execute("SELECT log_id, student_id, username, log_date, done, learned, understood, more, updated_date
                                     FROM students 
                                     INNER JOIN activities ON students.student_id = activities.log_student 
                                     WHERE student_id = ?
                                     ORDER BY log_date DESC", @user_id)
    end

    # 
    #        return @all_activity.first["username"]
    #end

    def log_activity(log_done, log_learned, log_understood, log_more)
        @dbhandler.db.execute("INSERT INTO activities 
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
        @dbhandler.db.execute("UPDATE activities
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
        @dbhandler.db.execute("DELETE FROM activities
                     WHERE log_id = ?", log_id);
    end

    #returns all activities of given userid
    def self.activity_factory(dbhandler, userid)
        @all_activity_hash = dbhandler.db.execute("SELECT log_id, student_id, username, log_date, done, learned, understood, more, updated_date
            FROM students 
            INNER JOIN activities ON students.student_id = activities.log_student 
            WHERE student_id = ?
            ORDER BY log_date DESC", userid)

        @all_activity = []
        @all_activity_hash.each { |activity| 
            @all_activity.push(Activity.new(
                dbhandler, 
                activity['student_id'],
                activity['log_id'],
                activity['username'],
                activity['log_date'],
                activity['done'],
                activity['learned'],
                activity['understood'],
                activity['more'],
                activity['updated_date'])) 
        }

        return @all_activity
    end
end