class Product < ActiveRecord::Base
  #associations
  belongs_to :categoria, :class_name => 'Category', :foreign_key => 'category_id'
  has_many :copias, :class_name => 'Copy'
  has_many :registros, :class_name => 'Record'
  
  #validations
  validates :nombre, presence: { message: " (El nombre no puede ser vacio)" }
  validates :nombre, format: { with: /[a-zA-Z][a-zA-Z0-9 \-']/ ,message: "(Solo esta permitido letras y numeros)" } 
  validates :nombre, uniqueness: { message: " (No puede haber 2 productos con el mismo nombre)" } 


  #methods
  
  def self.verificar_tope_mercado_libre_productos
    producto = []
    Product.all.each do |p|
      if (((p.registros.last.precio_venta + p.registros.last.cuenta_ml.monto_bruto) > Option.first.limite) && (p.registros.last.estado == "publicado"))
        producto.push p
      end
    end
    return producto
  end

end