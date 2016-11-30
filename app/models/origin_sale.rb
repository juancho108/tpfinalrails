class OriginSale < ActiveRecord::Base

  #validations
  #
  #validando nombre
  validates :nombre, presence: { message: " El nombre no puede ser vacio" }
  validates :nombre, uniqueness: { message: " (No puede haber 2 origenes de venta con el mismo nombre)" }
  #validates :nombre, format: { with: /\A\p{Alnum}+\z/,message: "Solo esta permitido letras y numeros" }

  #validando monto bruto
  validates :monto_bruto, presence: { message: " El nombre no puede ser vacio" }
  #validates_numericality_of :monto_bruto, message: "Solo se permiten numeros" 

  #validando monto neto
  validates :monto_neto, presence: { message: " El nombre no puede ser vacio" }
  #validates_numericality_of :monto_neto, message: "Solo se permiten numeros" 

  #methods
  #
  def actualizar_origen_de_la_venta precio_bruto, precio_neto
    self.monto_bruto += precio_bruto
    self.monto_neto += precio_neto
    self.save
  end

  def self.verificar_tope_mercado_libre 
    cuenta = []
    OriginSale.all.each do |os|
      if os.monto_bruto > Option.instance.limite
        cuenta.push os
      end
    end
    return cuenta
  end 

  def self.resetear_cuentas
    OriginSale.all.each do |os|  
      if Date.today.day == os.reset
        os.update monto_neto: 0.0
      end
    end
  end
end