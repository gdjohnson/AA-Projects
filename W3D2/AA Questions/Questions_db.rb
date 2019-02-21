require 'singleton'
require 'sqlite3'
require 'byebug'

class QuestionsDBConnection < SQLite3::Database
    include Singleton


    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Question 
    attr_accessor :title, :body, :author_id

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end 

    def self.all()
        data = QuestionsDBConnection.instance.execute(<<-SQL )
        SELECT * FROM questions 
        SQL
        data.map{|datum| Question.new(datum)}
    end

    def self.find_by_id(input_id)
        question_init = QuestionsDBConnection.instance.execute(<<-SQL, input_id)
            SELECT * FROM questions WHERE id = ?
        SQL
        return nil if question_init.empty?
        Question.new(question_init.first)
    end

    def self.find_by_author_id(author_id)
        question_init = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
            SELECT 
                * 
            FROM 
                questions 
            WHERE 
                author_id = ? 
            SQL
        question_init.map{|quest_data| Question.new(quest_data)}
    end

    def author 
        return User.find_by_id(self.author_id)
    end

     def replies 
        return Reply.find_by_question_id(self.id)
    end
end

class User
    attr_accessor :fname, :lname
    attr_reader :id

    def self.all
        data = QuestionsDBConnection.instance.execute('SELECT * FROM users')
        data.map { |datum| User.new(datum)}
    end

    def initialize(options)
        # debugger
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']

    end

    def self.find_by_id(input_id)
        user_init = QuestionsDBConnection.instance.execute(<<-SQL, input_id)
        SELECT 
            *
        FROM
            users
        WHERE
            id = ?
        SQL
        return nil if user_init.empty?
        User.new(user_init.first)
        # user_init.map{|user_info| User.new(user_info)}
    end

    def self.find_by_name(fname, lname)
        # debugger
        user_init = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL
        return nil if user_init.empty?
        user_init.map{|user_info| User.new(user_info)}
    end

    def authored_questions
        questions_data = Question.find_by_author_id(self.id)
        questions_data
    end

    def author_replies
        reply_data = Reply.find_by_user_id(self.id)
        return reply_data
    end

end

class Reply 
    attr_accessor :question_id, :parent_reply_id, :user_id, :body, :id

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @user_id = options['user_id']
        @body = options['body']
    end

    def self.all()
        data = QuestionsDBConnection.instance.execute(<<-SQL)
            SELECT * FROM replies
        SQL
        data.map{|datum| Reply.new(datum)}
    end

    def self.find_by_id(input_id)
        init_reply = QuestionsDBConnection.instance.execute(<<-SQL, input_id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL

        Reply.new(init_reply.first)
    end

    def self.find_by_user_id(input_user_id)
        init_reply = QuestionsDBConnection.instance.execute(<<-SQL, input_user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL

        Reply.new(init_reply.first)
    end

    def self.find_by_question_id(input_question_id)
        init_reply = QuestionsDBConnection.instance.execute(<<-SQL, input_question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL

        Reply.new(init_reply.first)
    end

    def author
        return User.find_by_id(self.user_id)
    end

    def question
        return Question.find_by_id(self.question_id)
    end

    def parent_reply 
        return Reply.find_by_id(self.parent_reply_id)
    end

    def child_replies
        children = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
            SELECT * FROM replies WHERE parent_reply_id = ?
        SQL

        children.map{|child| Reply.new(child)}
    end

end

class QuestionFollow
    attr_accessor :user_id, :question_id
    attr_reader :id
    def self.all 
        data = QuestionsDBConnection.instance.execute(<<-SQL)
            SELECT
                *
            FROM
                question_follows
        SQL
        data.map{|datum| QuestionFollow.new(datum)}
    end
    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.find_by_id(input_id)
        quest_data = QuestionsDBConnection.instance.execute(<<-SQL, input_id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?

        SQL
    end

    def self.followers_for_question_id(question_id)
        followers_data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
            SELECT 
                *
            FROM
                question_follows
            LEFT JOIN
                users
            ON user_id = users.id
            WHERE
                id = ?
            
        SQL
        followers_data.map{|datum| User.new(datum)}
    end

    def self.followed_questions_for_user_id(user_id)
        question_data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
            SELECT 
                * 
            FROM 
        SQL
    end
end

