class Category < ActiveRecord::Base
   # associations
  has_many :hijos, :class_name => 'Category', :foreign_key => 'category_id'
  has_many :productos, :class_name => 'Product'
  belongs_to :padre, :class_name => 'Category'
  
  #validations
  #
  #valiando nombre
  validates :nombre, presence: { message: " El nombre no puede ser vacio" }
  validates :nombre, format: { with: /\A\p{Alnum}+\z/,message: "Solo esta permitido letras y numeros" } 
end

