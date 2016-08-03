class Finance < ActiveRecord::Base

  #validations
  #
  #validando nombre
  validates :nombre, presence: { message: " El nombre no puede ser vacio" }
  validates :nombre, uniqueness: { message: " (No puede haber 2 cajas con el mismo nombre)" }

  #validando dinero
  validates :dinero, presence: { message: " Este campo no puede ser vacio" }
  
  #methods
  #
  def self.actualizarCaja caja_id, monto
    f = Finance.find(caja_id)
    f.dinero+= monto
    f.save
  end
end
