# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Cat.destroy_all

c1 = Cat.create(birth_date: '1995-03-31', name: 'Graham', color: 'Polish', sex: 'M', description: 'Cool cat')
c2 = Cat.create(birth_date: '1991-09-27', name: 'Max', color: 'Ukrainian', sex: 'M', description: 'Chill cat')
