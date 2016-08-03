class Product < ActiveRecord::Base
  #associations
  belongs_to :categoria, :class_name => 'Category', :foreign_key => 'category_id'
  has_many :copias, :class_name => 'Copy'
  has_many :registros, :class_name => 'Record'
  
  #validations
  validates :nombre, presence: { message: " (El nombre no puede ser vacio)" }
  validates :nombre, format: { with: /[a-zA-Z][a-zA-Z0-9 \-']/ ,message: "(Solo esta permitido letras y numeros)" } 
  validates :nombre, uniqueness: { message: " (No puede haber 2 productos con el mismo nombre)" } 
end
