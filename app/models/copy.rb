class Copy < ActiveRecord::Base
  # associations
  belongs_to :producto, :class_name => 'Product', :foreign_key => 'product_id'
  has_many :fotos, :class_name => 'Picture'

  #validations
  #
  #validando numero de serie
  validates :nro_serie, allow_blank: true, format: { with: /\A\p{Alnum}+\z/, message: "Solo esta permitido letras y numeros" } 

  #validando precio de compra
  validates_numericality_of :precio_compra, message: "Solo se permiten numeros"  

  #validando lugar
  validates :lugar, inclusion: { in: ['Departamento', 'Casa de Dario', 'Casa de Maxi','Deposito'],
    message: "El valor debe ser uno de los predefinidos" }

  #validando packaging
  validates :packaging, inclusion: { in: ['Original', 'Sin Caja', 'Caja Original Abierta','Generica'],
    message: "El valor debe ser uno de los predefinidos" }

  #validando estado
  validates :estado, inclusion: { in: ['Nuevo', 'Open-Box', 'A-Refurb','D-Refurb', 'Fallado'],
    message: "El valor debe ser uno de los predefinidos" }
end
