require 'date'
require_relative '../db_handler.rb'

class Activity
        
    attr_reader :user_id, 
                :activity_id, 
                :username, 
                :date, 
                :done, 
                :learned, 
                :understood, 
                :more, 
                :updated_date

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
    end

    def self.log_activity(dbhandler, userid, log_done, log_learned, log_understood, log_more)
        dbhandler.db.execute("INSERT INTO activities (log_student, 
                                                      done, 
                                                      learned, 
                                                      understood, 
                                                      more) 
                              VALUES (?, ?, ?, ?, ?)", 
                                userid, log_done, log_learned, log_understood, log_more);
    end

    def self.update_activity(dbhandler, edit_log_id, log_done, log_learned, log_understood, log_more)
        t = DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d %H:%M:%S")
        dbhandler.db.execute("UPDATE activities
                    SET done = ?,
                        learned = ?,
                        understood = ?,
                        more = ?,
                        updated_date = ?
                    WHERE log_id = ?", 
                    log_done, log_learned, log_understood, log_more, t, edit_log_id);
    end

    def self.delete_activity(dbhandler, log_id)
        dbhandler.db.execute("DELETE FROM activities
                     WHERE log_id = ?", log_id);
    end

    def self.get_all_activities_for_userid(dbhandler, userid)
        all_activities_for_user_hash = dbhandler.db.execute("SELECT log_id, student_id, username, log_date, done, learned, understood, more, updated_date
            FROM students 
            INNER JOIN activities ON students.student_id = activities.log_student 
            WHERE student_id = ?
            ORDER BY log_date DESC", userid)

        all_activities_for_user = []
        all_activities_for_user_hash.each { |activity| 
            all_activities_for_user.push(Activity.new(
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

        return all_activities_for_user
    end
    
end