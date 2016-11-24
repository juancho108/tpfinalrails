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
  def sumar_dinero 
    self.origen.dinero += self.monto_neto
    self.origen.save
  end

  def restar_dinero 
    self.origen.dinero -= self.monto_neto
    self.origen.save
  end

  def verificar_ingreso user
    #Si era un egreso con un destino, se genera un movimiento "Ingreso" Automático.
    if (self.tipo_operacion == 'Egreso') && (self.destino)
      Movement.create operacion: self.operacion+ " (autom.)", tipo_operacion: "Ingreso", monto_neto: self.monto_neto.abs, origen_id: self.destino_id, fecha_operacion: DateTime.now, persona: user.nombre+" "+user.apellido, socio_id: self.id
      self.hijo.origen.dinero -= self.monto_neto
      self.hijo.origen.save
    end
  end

  def revertir
    self.restar_dinero
    if (self.destino)
      self.hijo.restar_dinero
    end
  end

  def verificar_monto_bruto
    #verifico si al ser una venta, proviene de una cuenta MP y realizo los descuentos
    if self.origen.tipo_mp
      descuento = (self.monto_bruto*Option.first.porcentaje_mercadopago)/100
      neto = self.monto_bruto - descuento
      self.update(monto_neto: neto) 
    else
      self.update(monto_neto: self.monto_bruto)
    end
  end

  def editar_movimientos_de_dinero user
    self.sumar_dinero 
    if self.hijo #si tiene un movimiento automatico asociado, lo actualizo tmb
      self.hijo.destroy
      self.verificar_ingreso user
    end
  end

end
