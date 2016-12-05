class Sale < ActiveRecord::Base

  enum estado: [:concretada, :pendiente, :pago_parcial, :cancelada] 

  # associations
  belongs_to :copia, :class_name => 'Copy', :foreign_key => 'copy_id'
  belongs_to :cliente, :class_name => 'Client', :foreign_key => 'client_id'
  belongs_to :finance, :class_name => 'Finance', :foreign_key => 'finance_id'
  belongs_to :origin_sale, :class_name => 'OriginSale', :foreign_key => 'origin_sale_id'
  belongs_to :forma_de_pago, :class_name => 'Finance', :foreign_key => 'forma_de_pago_id'
  belongs_to :usuario, :class_name => 'User', :foreign_key => 'usuario_id'
  has_many :movements, :class_name => 'Movement', dependent: :destroy


  # methods
  
  def verificar_estado 

    #verifica el estado de la nueva venta y toma las acciones correspondientes  
    if self.pendiente? 
      #realiza las acciones correspondientes para una venta pendiente
      self.acciones_venta_pendiente
    elsif self.concretada?
      #realiza las acciones correspondientes al concretar una venta
      self.acciones_venta_concretada
    else #self.ago_parcial?
      self.acciones_venta_pago_parcial
    end
  end

  def anular_venta
    self.cancelada!
    self.copia.update estado_del_producto: "En Stock"
    self.origin_sale.actualizar_origen_de_la_venta((self.precio_bruto* -1), (self.precio_neto* -1))
    #verificar
    self.revertir_finance
  end

  def acciones_venta_concretada
    #actualizo el estado de la copia
    self.copia.update(estado_del_producto: "Vendido")

    #actualizo el precio neto de la venta
    precio_neto = self.calcular_precio_neto
    self.update(precio_neto: precio_neto)
   
    #crea un nuevo movimiento
    Movement.create operacion: self.copia.producto.nombre, tipo_operacion: "Venta", origen_id: self.forma_de_pago_id, monto_neto: self.precio_neto, fecha_operacion: DateTime.now, persona: self.usuario.nombre+' '+self.usuario.apellido, sale_id: self.id    
    
    #actualizo la ganancia
    ganancia = self.calcular_ganancia
    self.update(ganancia: ganancia)

    #actualiza la caja con el dinero ingresado
    self.forma_de_pago.actualizar_caja(self.precio_neto)

    #actualiza montos de origen de la venta (quede pendiente o no, en caso de no ser confirmada se restan)
    self.origin_sale.actualizar_origen_de_la_venta(self.precio_bruto, self.precio_neto)

    #verificar si excede el monto limite de ML
    OriginSale.verificar_tope_mercado_libre
  end

  def acciones_venta_pendiente
    #actualiza el estado de la copia
    self.copia.update(estado_del_producto: "Reservado")
    
    #actualiza el precio neto de la venta
    precio_neto = self.calcular_precio_neto
    self.update(precio_neto: precio_neto)

    #actualiza el origen de la venta
    self.origin_sale.actualizar_origen_de_la_venta(self.precio_bruto, self.precio_neto)

    #verifica si se pasa del monto tope para cuentas de ml
    OriginSale.verificar_tope_mercado_libre
  end

  def acciones_venta_pago_parcial
    #actualiza el estado de la copia
    self.copia.update(estado_del_producto: "Reservado")

    #actualizo la forma de pago, en este caso tiene varias, por lo cual forma_de_pago_id es null
    self.update(forma_de_pago_id: nil)
    
    #quizá actualizar la caja: Finance.actualizar_caja(sale.forma_de_pago_id, sale.precio_neto)
    (self.cantidad_de_pagos).times do 
      Movement.create operacion: self.copia.producto.nombre, tipo_operacion: "Venta", sale_id: self.id, monto_neto: 0.0
    end
  end

  def acciones_venta_concretada_desde_pendiente
    #actualizo estado de la venta
    self.concretada!
    #actualizo el estado de la copia
    self.copia.update(estado_del_producto: "Vendido")

    #crea un nuevo movimiento
    Movement.create operacion: self.copia.producto.nombre, tipo_operacion: "Venta", origen_id: self.forma_de_pago_id, monto_neto: self.precio_neto, fecha_operacion: DateTime.now, persona: self.usuario.nombre+' '+self.usuario.apellido, sale_id: self.id    
    
    #actualizo la ganancia
    ganancia = self.calcular_ganancia
    self.update(ganancia: ganancia)

    #actualiza la caja con el dinero ingresado
    self.forma_de_pago.actualizar_caja(self.precio_neto)
  end
  
  def acciones_venta_concretada_desde_pago_parcial user
    ganancia = self.calcular_ganancia
    dinero_neto = self.movements.inject(0){|total,m| total + m.monto_neto} #dinero sumado de las x formas de pago
    dinero_bruto = self.movements.inject(0){|total,m| total + m.monto_bruto} #dinero sumado de las x formas de pago
    self.update estado: 0, usuario: user, ganancia: ganancia, precio_neto: dinero_neto, precio_bruto: dinero_bruto
    self.copia.update estado_del_producto: "Vendido"
    #actualizo las cajas en base a los movimientos de la venta
    self.movements.each do |m|
      m.origen.actualizar_caja(m.monto_neto)
    end
  end

=begin
  def self.verificar_cambio_de_estado estado_anterior, sale, user
    if estado_anterior == "Cancelada"
      if sale.estado == "Concretada"
        #verificar que la copia ahora ya no esté vendida, si esta vendida dialogo 
        #para ver si queire vender otra o dejar cancelada la venta
        Sale.acciones_venta_concretada(sale, user)
      else # sale.estado == "Pendiente"
        sale.copia.update estado_del_producto: "Reservado"
      end
      sale.origin_sale.actualizar_origen_de_la_venta(sale.precio_bruto, sale.precio_neto)      
    elsif estado_anterior == "Concretada"
      #revertir montos en Finance y Eliminar todos los movements de esa venta
      if sale.estado == "Pendiente"
        #recuperar estado de copy como RESERVADO
        sale.copia.update(estado_del_producto: "Reservado")
      else #sale.estado == "Cancelada"
        #recuperar estado de copy como"En Stock"
        sale.copia.update(estado_del_producto: "En Stock")
        #revertir montos en OriginSale correspondiente
        sale.origin_sale.actualizar_origen_de_la_venta( (sale.precio_bruto* -1), (sale.precio_neto* -1))
      end
      Sale.revertir_finance(sale)
      sale.movements.delete_all #elimino los movimientos
    end
  end
=end
  def revertir_finance 
    #descuenta de la CAJA correspondiente el valor sumado anteriormente
    self.movements.each do |m|
      m.origen.actualizar_caja(m.monto_neto* -1)
    end
  end
=begin
  def self.verificar_cambios sale, modified_sale, user
    #verifica si cambio el estado
    Sale.verificar_cambio_de_estado(sale.estado, modified_sale, user) if sale.estado != modified_sale.estado 

    #verifica si cambio el importe
    
    #verifica si cambio el 
  end
=end
  def calcular_ganancia
    dolar = Option.instance.dolar_libre.to_f
    dinero_acumulado =  self.movements.inject(0) do |total,m|
                           total + m.monto_neto
                        end
    precio_en_dolares = (dinero_acumulado / dolar)
    return (precio_en_dolares - self.copia.precio_compra.to_f)
  end

  def calcular_precio_neto
    if (self.origin_sale.tipo?) && (self.forma_de_pago.tipo_mp?) #es Mercadolibre y Mercadopago
      porcentaje_descuento = Option.instance.porcentaje_ml_mp
    elsif (self.origin_sale.tipo?) #es Solo Mercadolibre
      porcentaje_descuento = Option.instance.porcentaje_mercadolibre
    elsif (self.forma_de_pago.tipo_mp?) #es tipo Mercadopago
      porcentaje_descuento = Option.instance.porcentaje_mercadopago
    else #no es nada anterior
      return self.precio_bruto
    end
    descuento = (porcentaje_descuento * self.precio_bruto)/100
    return (self.precio_bruto - descuento) 
  end


end
