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
  def self.actualizarOrigenDeLaVenta precio_bruto, precio_neto, origen_id
    a = OriginSale.find(origen_id)
    a.monto_bruto += precio_bruto
    a.monto_neto += precio_neto
    a.save
  end
end
