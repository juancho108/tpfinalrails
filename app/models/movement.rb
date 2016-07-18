class Movement < ActiveRecord::Base
#Relations
  belongs_to :origen, :class_name => 'Finance', :foreign_key => 'origen_id'
  belongs_to :destino, :class_name => 'Finance', :foreign_key => 'destino_id'
  belongs_to :venta, :class_name => 'Sale', :foreign_key => 'sale_id'
#Validations
#
#validando operacion
validates :operacion, presence: { message: " Este campo no puede ser vacio" }
#validates :operacion, format: { with: /\A\p{Alnum}+\z/,message: "Solo esta permitido letras y numeros" } 

#validando tipo de operacion
validates :tipo_operacion, inclusion: { in: ['Ajuste','Compra','Venta','Ingreso','Egreso','Sueldo','Pago Tarjeta','Factura'],
    message: "El valor debe ser uno de los predefinidos" }

#validando monto neto
#validates_numericality_of :monto_neto, message: "Solo se permiten numeros" 



#Methods
#
  def self.verificarIngreso movement
    #Si era un egreso con un destino, se genera un movimiento "Ingreso" Automático.
    if (movement.tipo_operacion == 'Egreso') && (movement.destino)
      Movement.create operacion: movement.operacion+ " (autom.)", tipo_operacion: "Ingreso", monto_neto: movement.monto_neto.abs, origen_id: movement.origen_id, destino_id: movement.destino_id, fecha_operacion: DateTime.now  #agregar quien cargó
      movement.destino.dinero -= movement.monto_neto
      movement.destino.save
    end
  end
end
