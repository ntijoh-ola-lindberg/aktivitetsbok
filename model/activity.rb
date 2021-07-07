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
                :date_updated

    def initialize (dbhandler, user_id, activity_id=nil, username=nil, date=nil, done=nil, learned=nil, understood=nil, more=nil, date_updated=nil)
        @dbhandler = dbhandler 

        @user_id = user_id
        @activity_id = activity_id
        @username = username
        @date = date
        @done = done
        @learned = learned
        @understood = understood
        @more = more
        @date_updated = date_updated
    end

    def log_activity()
        @dbhandler.db.execute("INSERT INTO activities (user_id, 
                                                      done, 
                                                      learned, 
                                                      understood, 
                                                      more) 
                              VALUES (?, ?, ?, ?, ?)", 
                                Integer(@user_id), @done, @learned, @understood, @more);
    end
    
    def update_activity(done_updated, learned_updated, understood_updated, more_updated)
        t = DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d %H:%M:%S")
        @dbhandler.db.execute("UPDATE activities
                    SET done = ?,
                        learned = ?,
                        understood = ?,
                        more = ?,
                        date_updated = ?
                    WHERE activities.id = ?", 
                    done_updated, learned_updated, understood_updated, more_updated, t, @activity_id);
    end

    def delete_activity()
        @dbhandler.db.execute("DELETE FROM activities
                     WHERE activities.id = ?", @activity_id);
    end


    def self.get_all_activities_for_userid(dbhandler, userid)
        all_activities_for_user_hash = dbhandler.db.execute("SELECT users.id as u_id, users.username, activities.id as a_id, activities.date, activities.date_updated, activities.done, activities.learned, activities.understood, activities.more 
            FROM users 
            INNER JOIN activities ON u_id = activities.user_id 
            WHERE u_id = ?
            ORDER BY date DESC", userid)

        all_activities_for_user = []
        all_activities_for_user_hash.each { |activity| 
            all_activities_for_user.push(
                Activity.new(
                    dbhandler, 
                    activity['u_id'],
                    activity['a_id'],
                    activity['username'],
                    activity['date'],
                    activity['done'],
                    activity['learned'],
                    activity['understood'],
                    activity['more'],
                    activity['date_updated']
                )
            ) 
        }

        return all_activities_for_user
    end

end