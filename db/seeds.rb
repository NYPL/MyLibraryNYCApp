# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

File.open 'db/seed-data.sql', 'r' do |f|
  connection = ActiveRecord::Base.connection
  database_array = ['schema_migrations','holds','users','sierra_code_zcode_matches']
  connection.tables.each do |table|
    #connection.execute("TRUNCATE #{table}") unless database_array.include? table
  end

  statements = f.read.split(/;$/)
  statements.pop # the last empty statement
  puts "Seeding from #{statements.size} statement dump"
 
  ActiveRecord::Base.transaction do
    statements.each do |statement|
      puts statement
      connection.execute(statement)
    end
  end
end
