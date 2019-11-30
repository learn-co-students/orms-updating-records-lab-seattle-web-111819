require_relative "../config/environment.rb"

class Student

  attr_accessor :id, :name, :grade

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.all(query="")
    DB[:conn].execute("SELECT * FROM students " + query).map {|student| new_from_db(student)}
  end
  

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students;")
  end

  def save
    if @id
      update
    else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?);", @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end
  end

  def self.create(name, grade)
    new(name, grade).save
  end

  def self.new_from_db(row)
    new(row[1], row[2], row[0])
  end
  
  def self.find_by_name(name)
    all("WHERE name = '#{name}' LIMIT 1;")[0]
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?;", @name, @grade, @id)
  end

end
