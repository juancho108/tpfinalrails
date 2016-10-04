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
User.create(email: "marianofrias@gmail.com ", password:"mariano1", password_confirmation: "mariano1", role: 0, nombre: "Mariano", apellido: "Frias")

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

#Origin Sales
OriginSale.create(nombre: "ML Maxi", tipo: true)
OriginSale.create(nombre: "ML Nelida", tipo: true)
OriginSale.create(nombre: "ML Dario", tipo: true)
OriginSale.create(nombre: "ML Cristina", tipo: true)
OriginSale.create(nombre: "ML Norma", tipo: true)
OriginSale.create(nombre: "ML Fabian", tipo: true)
OriginSale.create(nombre: "ML Rocio", tipo: true)
OriginSale.create(nombre: "ML Anabela", tipo: true)
OriginSale.create(nombre: "ML Olga", tipo: true)
OriginSale.create(nombre: "ML Isabel", tipo: true)
OriginSale.create(nombre: "ML Matias", tipo: true)
OriginSale.create(nombre: "ML Juan", tipo: true)
OriginSale.create(nombre: "ML Sebastian", tipo: true)
OriginSale.create(nombre: "ML Susana", tipo: true)
OriginSale.create(nombre: "Pagina DS", tipo: false)
OriginSale.create(nombre: "Otros", tipo: false)

#Finances
Finance.create(nombre: "Efectivo Dario", tipo_mp: false)
Finance.create(nombre: "Efectivo Maxi", tipo_mp: false)
Finance.create(nombre: "Banco Sant. Dario", tipo_mp: false)
Finance.create(nombre: "Banco Sant. Maxi", tipo_mp: false)
Finance.create(nombre: "Banco Comaf. Eduardo", tipo_mp: false)
Finance.create(nombre: "Banco Sant. Federico", tipo_mp: false)
Finance.create(nombre: "Banco Facundo", tipo_mp: false)
Finance.create(nombre: "Banco Patag. Dario", tipo_mp: false)
Finance.create(nombre: "Banco Cintia", tipo_mp: false)
Finance.create(nombre: "Banco Maria", tipo_mp: false)
Finance.create(nombre: "Banco Juan Jose", tipo_mp: false)
Finance.create(nombre: "Banco Sebastian", tipo_mp: false)
Finance.create(nombre: "MP Maxi", tipo_mp: true)
Finance.create(nombre: "MP Nelida", tipo_mp: true)
Finance.create(nombre: "MP Dario", tipo_mp: true)
Finance.create(nombre: "MP Cristina", tipo_mp: true)
Finance.create(nombre: "MP Norma", tipo_mp: true)
Finance.create(nombre: "MP Fabian", tipo_mp: true)
Finance.create(nombre: "MP Rocio", tipo_mp: true)
Finance.create(nombre: "MP Anabela", tipo_mp: true)
Finance.create(nombre: "MP Olga", tipo_mp: true)
Finance.create(nombre: "MP Isabel", tipo_mp: true)
Finance.create(nombre: "MP Matias", tipo_mp: true)
Finance.create(nombre: "MP Juan", tipo_mp: true)
Finance.create(nombre: "MP Sebastian", tipo_mp: true)
Finance.create(nombre: "MP Susana", tipo_mp: true)

