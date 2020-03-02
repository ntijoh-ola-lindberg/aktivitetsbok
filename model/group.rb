require_relative '../db_handler.rb'
require_relative 'user.rb'

class Group

    attr_reader :id, :name, :students, :teachers

    def initialize(db_handler, id, name, students=nil, teachers=nil)

        @db_handler = db_handler
        @id = id
        @name = name

        @studends = []
        @teachers = []
    end

    def add_user(user, group_role)
        if group_role == 1
            p "Adding user to #{@name} as teacher: #{user.name}"
            #@teachers.push(user)
        elsif group_role == 2
            #@students.push(user)
            p "Adding user to #{@name} as student: #{user.name}"
        end

    end

    def self.get_all_groups_for_userid(db_handler, admin_user_id)
        all_groups_for_user_hash = db_handler.db.execute("SELECT groups.id, name, date_created, group_id, user_id, group_role, username, password_hash, global_role
                                                     FROM groups 
                                                     JOIN groups_users ON groups.id = groups_users.group_id
                                                     JOIN users ON users.id = groups_users.user_id
                                                     ORDER BY group_id")
        
        all_groups = []

        #add all groups
        all_groups_for_user_hash.each { |g| 
            p "Debug: '#{g['group_id']}', '#{g['name']}'"
            all_groups.push(Group.new(db_handler, g['group_id'], g['name'], nil, nil))
        }

        all_groups.each { |debug| p "Debug: p.group_name'#{debug.name}'"}

        #add users to correct group
        all_groups_for_user_hash.each { |group| 
            #global_role, id, username, password_hash)
            user = User.get_user(
                group['global_role'],
                group['user_id'],
                group['username'],
                group['password_hash']
            )

            p "User: #{user.name}"

            group_to_add = all_groups.detect { |ag| 
                p "#{ag.id} , #{group['group_id']}"
                ag.id == group['group_id'] 
            }

            p "#{group_to_add.name}"

            group_to_add.add_user(user, group['group_role'])
        }


        return all_groups
    end
end
