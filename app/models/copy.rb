class Copy < ActiveRecord::Base
  # associations
  belongs_to :producto, :class_name => 'Product', :foreign_key => 'product_id'
  has_many :fotos, :class_name => 'Picture'

  #validations
  #
  #validando numero de serie
  validates :nro_serie, allow_blank: true, format: { with: /[a-zA-Z][a-zA-Z0-9 \-']/, message: "Solo esta permitido letras y numeros" } 
  validates :nro_serie, uniqueness: { message: " (No puede haber 2 numeros de serie iguales)" }
  
  #validando precio de compra
  validates :precio_compra, presence: { message: " (El Precio de compra no puede ser vacio)" }

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
