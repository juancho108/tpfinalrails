# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: "jjf108@gmail.com ", password:"arsenal1", password_confirmation: "arsenal1", role: 2, nombre: "Juan", apellido: "Ferreyra")
Option.create(skin: "blue")