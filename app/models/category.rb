class Category < ActiveRecord::Base
   # associations
  has_many :hijos, :class_name => 'Category', :foreign_key => 'padre_id'
  has_many :productos, :class_name => 'Product'
  belongs_to :padre, :class_name => 'Category'
  
  #validations
  #
  #valiando nombre
  validates :nombre, presence: { message: " El nombre no puede ser vacio" }
  validates :nombre, format: { with: /[a-zA-Z][a-zA-Z0-9 \-']/ ,message: "Solo esta permitido letras y numeros" } 

  #methods
  #
  def nombre_y_padre
    "#{nombre} >> #{padre.nombre}" rescue "#{nombre}"
  end

  def self.categoriesForProducts
    Category.all.select do |c| 
      (c.padre_id != nil) || (c.hijos.count == 0)
    end
  end
end

