class Dog 
  attr_accessor :name, :breed, :id
  
  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id 
  end 
  
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT);
      SQL
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs;"
    DB[:conn].execute(sql)
  end 
  
  def self.new_from_db(row)
    new_dog = self.new(name: nil, breed: nil)
    new_dog.id = row[0]
    new_dog.name = row[1]
    new_dog.breed = row[2]
    new_dog
  end
  
  def save
    if self.id 
      sql = "UPDATE TABLE dogs SET name = ?, breed = ? WHERE id = ?;"
      DB[:conn].execute(sql, self.name, self.breed, self.id)
    else 
      sql = "INSERT INTO dogs (name, breed) VALUES (?, ?);"
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end 
  end 
  
  def self.find_by_name(name)
    sql = "SELECT * FROM dogs WHERE name = ? LIMIT 1;"
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end 
  
  def update
    sql = "UPDATE TABLE dogs SET name = ?, breed = ? WHERE id = ?;"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end 
  
  
    
end 