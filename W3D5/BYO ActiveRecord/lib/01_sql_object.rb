require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    if @columns.nil?
      table = self.table_name
      results = DBConnection.execute2(<<-SQL)
      SELECT 
        * 
      FROM 
        #{table}
      SQL
      @columns = results[0].map {|col| col.to_sym}
    end
    @columns
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) do
        attributes[column]
      end
      # debugger
      define_method("#{column}=") do |val|
        attributes[column] = val
      end
    end
  end
  
  def self.table_name
    unless @table_name
      @table_name = self.to_s.tableize
    end
    @table_name
  end

  def self.table_name=(table_name)
    @table_name = table_name 
  end

  def self.all
    table = self.table_name
    data = DBConnection.execute(<<-SQL)
    SELECT
      #{table}.*
    FROM
      #{table}
    SQL
    self.parse_all(data)
  end

  def self.parse_all(results)
    objects = []
    results.each do |row|
      objects << self.new(row)
    end
    objects
  end

  def self.find(id)
    table = self.table_name
    result = DBConnection.execute(<<-SQL, id)
    SELECT *
    FROM #{table}
    WHERE #{table}.id = ?
    SQL
    return nil if result.empty? 
    self.new(*result)
  end

  def initialize(params = {})
    # debugger
    params.each do |k, v|
      unless self.class.columns.include?(k.to_sym)
        raise Exception.new("unknown attribute '#{k}'")
      end
      self.send("#{k}=", v)
    end
  end

  def attributes
    @attributes = Hash.new unless @attributes
    @attributes
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
