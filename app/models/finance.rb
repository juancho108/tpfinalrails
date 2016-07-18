class Finance < ActiveRecord::Base

  #validations
  #
  #validando nombre
  validates :nombre, presence: { message: " El nombre no puede ser vacio" }
  #validates :nombre, format: { with: /\A\p{Alnum}+\z/,message: "Solo esta permitido letras y numeros" }

  #validando dinero
  validates :dinero, presence: { message: " Este campo no puede ser vacio" }
  validates_numericality_of :dinero, message: "Solo se permiten numeros"


  #methods
  #
  def self.actualizarCaja caja_id, monto
    f = Finance.find(caja_id)
    f.dinero+= monto
    f.save
  end
end
