require_relative '../db_handler.rb'
require_relative 'user.rb'

class Group

    attr_reader :id, :name, :students, :teachers

    def initialize(db_handler, id, name, students=nil, teachers=nil)

        @db_handler = db_handler
        @id = id
        @name = name

        unless students.nil?
            @students = students
        else
            @students = []
        end

        unless teachers.nil?
            @teachers = teachers
        else
            @teachers = []
        end

    end

    def to_s
        "Group id: #{@id}, name: #{@name}, students: #{@students.length},  teachers: #{@teachers.length}"
    end

    def add_user(user, group_role)
        if group_role == 1
            @teachers.push(user)
        elsif group_role == 2
            @students.push(user)
        end
    end

    def self.get_all_groups_for_userid(db_handler, admin_user_id)
        all_groups_for_user_hash = db_handler.db.execute("SELECT groups.id, name, date_created, group_id, user_id, group_role, username, password_hash, global_role
                                                     FROM groups 
                                                     JOIN groups_users ON groups.id = groups_users.group_id
                                                     JOIN users ON users.id = groups_users.user_id
                                                     ORDER BY group_id")
        
                                                     #todo: Add where clause - currently selecting all groups
        
        all_groups = []

        # Add all groups that aren't in the list
        all_groups_for_user_hash.each { |g| 
            unless all_groups.detect { |duplicate| duplicate.id == g['group_id'] }
                all_groups.push(Group.new(db_handler, g['group_id'], g['name'], nil, nil))
            end
        }

        # Add all users to correct group or groups
        #  1 Create an User object from hash
        #  2 Find correct group based on users group id
        #  3 Add user to the list of users in that group (with role)
        all_groups_for_user_hash.each { |group| 
            user = User.get_user(group['global_role'], group['user_id'], group['username'], group['password_hash'])
            searched_user_group = all_groups.detect { |ag| ag.id == group['group_id'] }
            searched_user_group.add_user(user, group['group_role'])
        }

        return all_groups
    end
end
