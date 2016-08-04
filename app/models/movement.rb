class Movement < ActiveRecord::Base
#Relations
  belongs_to :origen, :class_name => 'Finance', :foreign_key => 'origen_id'
  belongs_to :destino, :class_name => 'Finance', :foreign_key => 'destino_id'
  belongs_to :venta, :class_name => 'Sale', :foreign_key => 'sale_id'
  belongs_to :socio, :class_name => 'Movement'
  has_one :hijo, :class_name => 'Movement', :foreign_key => 'socio_id', dependent: :destroy
#Validations
#
#validando operacion
validates :operacion, presence: { message: " Este campo no puede ser vacio" }
#validates :operacion, format: { with: /\A\p{Alnum}+\z/,message: "Solo esta permitido letras y numeros" } 

#validando tipo de operacion
validates :tipo_operacion, inclusion: { in: ['Ajuste','Compra','Venta','Ingreso','Egreso','Sueldo','Pago Tarjeta','Factura'],
    message: "El valor debe ser uno de los predefinidos" }

#validando monto neto
#validates :monto_neto, presence: { message: " Este campo no puede ser vacio" }



#Methods
#
  def self.sumarDinero movement
    movement.origen.dinero += movement.monto_neto
    movement.origen.save
  end

  def self.restarDinero movement
    movement.origen.dinero -= movement.monto_neto
    movement.origen.save
  end

  def self.verificarIngreso movement, user
    #Si era un egreso con un destino, se genera un movimiento "Ingreso" Automático.
    if (movement.tipo_operacion == 'Egreso') && (movement.destino)
      Movement.create operacion: movement.operacion+ " (autom.)", tipo_operacion: "Ingreso", monto_neto: movement.monto_neto.abs, origen_id: movement.destino_id, fecha_operacion: DateTime.now, persona: user.nombre+" "+user.apellido, socio_id: movement.id
      movement.destino.dinero -= movement.monto_neto
      movement.destino.save
    end
  end

  def self.revertir movement
    Movement.restarDinero(movement)
    if (movement.destino)
      Movement.restarDinero(movement.hijo)
    end
  end

  def self.verificarMontoBruto movement
    #verifico con los descuentos
    if movement.origen.tipo_mp
      descuento = (movement.monto_bruto*Option.first.porcentaje_mercadopago)/100
      neto = movement.monto_bruto - descuento
      movement.update(monto_neto: neto) 
    else
      movement.update(monto_neto: movement.monto_bruto)
    end
  end
end
