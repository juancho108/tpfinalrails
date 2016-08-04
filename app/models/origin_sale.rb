class OriginSale < ActiveRecord::Base

  #validations
  #
  #validando nombre
  validates :nombre, presence: { message: " El nombre no puede ser vacio" }
  #validates :nombre, format: { with: /\A\p{Alnum}+\z/,message: "Solo esta permitido letras y numeros" }

  #validando monto bruto
  validates :monto_bruto, presence: { message: " El nombre no puede ser vacio" }
  #validates_numericality_of :monto_bruto, message: "Solo se permiten numeros" 

  #validando monto neto
  validates :monto_neto, presence: { message: " El nombre no puede ser vacio" }
  #validates_numericality_of :monto_neto, message: "Solo se permiten numeros" 

  #methods
  #
  def self.actualizarOrigenDeLaVenta precio_bruto, precio_neto, origin_sale
    origin_sale.monto_bruto += precio_bruto
    origin_sale.monto_neto += precio_neto
    origin_sale.save
  end
end
