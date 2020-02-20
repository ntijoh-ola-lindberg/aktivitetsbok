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

    def initialize (dbhandler, user_id, activity_id=nil, username=nil, date=nil, done=nil, learned=nil, understood=nil, more=nil, updated_date=nil)
        @dbhandler = dbhandler 

        @user_id = user_id
        @activity_id = activity_id
        @username = username
        @date = date
        @done = done
        @learned = learned
        @understood = understood
        @more = more
        @updated_date = updated_date
    end

    def log_activity()
        @dbhandler.db.execute("INSERT INTO activities (log_student, 
                                                      done, 
                                                      learned, 
                                                      understood, 
                                                      more) 
                              VALUES (?, ?, ?, ?, ?)", 
                                @user_id, @done, @learned, @understood, @more);
    end
    
    def update_activity(done_updated, learned_updated, understood_updated, more_updated)
        t = DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d %H:%M:%S")
        @dbhandler.db.execute("UPDATE activities
                    SET done = ?,
                        learned = ?,
                        understood = ?,
                        more = ?,
                        updated_date = ?
                    WHERE log_id = ?", 
                    done_updated, learned_updated, understood_updated, more_updated, t, @activity_id);
    end

    def self.delete_activity(dbhandler, log_id)
        dbhandler.db.execute("DELETE FROM activities
                     WHERE log_id = ?", log_id);
    end

    # Static methods below 
    # TODO move to general factory

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