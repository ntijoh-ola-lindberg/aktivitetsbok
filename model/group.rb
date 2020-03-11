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
        "Group id: #{@id}, name: #{@name}, no. of students: #{@students.length},  no. of teachers: #{@teachers.length}"
    end

    def add_user(user, group_teacher)
        if group_teacher
            gt = 1
        elsif group_teacher
            gt = 2
        end

        #todo: move to User
        e = @db_handler.db.execute("INSERT INTO users (username, password_hash, global_role) VALUES (?,?,?)", user.username, user.password_hashed, gt)
        result = @db_handler.db.execute("SELECT id FROM users WHERE username == (?)",user.username).first

        @db_handler.db.execute("INSERT INTO groups_users (group_id, user_id, group_role) VALUES (?,?,?)", @id, result['id'], gt)
    end

    def self.get_all_groups(db_handler)
        all_groups_for_user_hash = db_handler.db.execute("SELECT groups.id, name, date_created, group_id, user_id, group_role, username, password_hash, global_role
                                                     FROM groups 
                                                     JOIN groups_users ON groups.id = groups_users.group_id
                                                     JOIN users ON users.id = groups_users.user_id
                                                     ORDER BY group_id")
        
        all_groups = []

        all_groups_for_user_hash.each { |g| 
            new_user = User.get_user(g['global_role'], g['user_id'], g['username'], g['password_hash'])
            
            group = all_groups.detect { |dup| dup.id == g['group_id'] }
            unless group
                group = Group.new(db_handler, g['group_id'], g['name'], nil, nil)
                all_groups.push(group)
            end

            if g['group_role'] == 1 
                group.teachers.push(new_user)
            elsif g['group_role'] == 2 
                group.students.push(new_user)
            end
        }

        return all_groups
    end
end
