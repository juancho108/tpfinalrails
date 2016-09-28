# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Usuarios
User.create(email: "jjf108@gmail.com ", password:"arsenal1", password_confirmation: "arsenal1", role: 2, nombre: "Juan", apellido: "Ferreyra")
User.create(email: "dariogabalec@gmail.com ", password:"tiempoa13", password_confirmation: "tiempoa13", role: 1, nombre: "Dario", apellido: "Gabalec")
User.create(email: "marianofrias@gmail.com ", password:"porota1", password_confirmation: "porota1", role: 0, nombre: "Mariano", apellido: "Frias")

#Opciones
Option.create(skin: "blue")

#Categorias
Category.create(nombre: "Tablets")
Category.create(nombre: "Camaras Digitales")
Category.create(nombre: "Memorias")
Category.create(nombre: "Discos")
Category.create(nombre: "E-Readers")
Category.create(nombre: "Otros")
Category.create(nombre: "Notebooks")
Category.create(nombre: "Consolas")
Category.create(nombre: "Celulares")
Category.create(nombre: "Monitores")
Category.create(nombre: "Smartwatches")

tablets = Category.find_by(nombre: "Tablets")
camaras = Category.find_by(nombre: "Camaras Digitales")
memorias = Category.find_by(nombre: "Memorias")
discos = Category.find_by(nombre: "Discos")
readers = Category.find_by(nombre: "E-Readers")
otros = Category.find_by(nombre: "Otros")
notebooks = Category.find_by(nombre: "Notebooks")
consolas = Category.find_by(nombre: "Consolas")

tablets.hijos.create(nombre: "Apple Ipad")
tablets.hijos.create(nombre: "Android")
tablets.hijos.create(nombre: "Windows")
tablets.hijos.create(nombre: "Fundas")

camaras.hijos.create(nombre: "Reflex")
camaras.hijos.create(nombre: "Semi-Reflex")
camaras.hijos.create(nombre: "Compactas")
camaras.hijos.create(nombre: "Videocamaras")
camaras.hijos.create(nombre: "Estuches-Bolsos")
camaras.hijos.create(nombre: "Lentes")

memorias.hijos.create(nombre: "SD")
memorias.hijos.create(nombre: "Micro-SD")
memorias.hijos.create(nombre: "Pendrives")

discos.hijos.create(nombre: "SSD")
discos.hijos.create(nombre: "Discos Externos")

readers.hijos.create(nombre: "Kindle Amazon")
readers.hijos.create(nombre: "Sony")
readers.hijos.create(nombre: "Fundas")

otros.hijos.create(nombre: "Varios")
otros.hijos.create(nombre: "Cables-Cargadores")

notebooks.hijos.create(nombre: "Hasta 11,6")
notebooks.hijos.create(nombre: "11,6 a 15,6")
notebooks.hijos.create(nombre: "Mayor a 15,6")

consolas.hijos.create(nombre: "Sony")
consolas.hijos.create(nombre: "Nintendo")
consolas.hijos.create(nombre: "Microsoft")