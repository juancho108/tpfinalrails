class Sale < ActiveRecord::Base

  # associations
  belongs_to :copia, :class_name => 'Copy', :foreign_key => 'copy_id'
  belongs_to :cliente, :class_name => 'Client', :foreign_key => 'client_id'
  belongs_to :finance, :class_name => 'Finance', :foreign_key => 'finance_id'
  belongs_to :origin_sale, :class_name => 'OriginSale', :foreign_key => 'origin_sale_id'
  belongs_to :forma_de_pago, :class_name => 'Finance', :foreign_key => 'forma_de_pago_id'
  belongs_to :usuario, :class_name => 'User', :foreign_key => 'usuario_id'
  has_many :movements, :class_name => 'Movement', dependent: :destroy

  def self.crearVenta params, copy, dolar, user

    descuento = (params[:precio_bruto].to_f * 0.11) # - descuentos ML (11%)
    precio_neto = params[:precio_bruto].to_f - descuento
    ganancia = (precio_neto / dolar) - copy.precio_compra
    #estado = params[:estado]
    #raise

    #creo nuevo Cliente
    cliente = Client.create nombre: params[:nombre], mail: params[:mail], detalle_adicional: params[:detalle]
    
    #creo la nueva venta
    sale = Sale.create precio_bruto: params[:precio_bruto].to_f, forma_de_pago_id: params[:forma_de_pago_id], precio_neto: precio_neto, ganancia: ganancia, copy_id: copy.id, origin_sale_id: params[:origin_sale_id], cliente: cliente, estado: params[:estado], usuario: user, cantidad_de_pagos: params[:cantidad_de_pagos]      
    
    #verifica el estado de la nueva venta y toma las acciones correspondientes  
    if params[:estado] == "Pendiente" 
      copy.estado_del_producto = "Reservado"
    elsif params[:estado] == "Concretada"
      copy.estado_del_producto = "Vendido"
    
      #realiza las acciones correspondientes al concretar una venta
      Sale.accionesVentaConcretada(sale, user)
    else #params[:estado] == "Pago Parcial"
      copy.estado_del_producto = "Reservado"
      Sale.accionesVentaPagoParcial(sale, user)
    end
    
    #actualiza montos de origen de la venta (quede pendiente o no, en caso de no ser confirmada se restan)
    OriginSale.actualizarOrigenDeLaVenta(params[:precio_bruto].to_f, precio_neto, params[:origin_sale_id])
    copy.save
  end

  #resta el dinero en la cuenta de ML correspondiente y devuelve el producto al stock
  def self.anularVenta sale
    sale.update estado: "Cancelada"
    sale.copia.update estado_del_producto: "En Stock"
    OriginSale.actualizarOrigenDeLaVenta( (sale.precio_bruto* -1), (sale.precio_neto* -1), sale.origin_sale_id)
    #verificar
    Sale.revertirFinance(sale)
  end

  def self.accionesVentaConcretada sale, user
    #crea un nuevo movimiento
    Movement.create operacion: sale.copia.producto.nombre, tipo_operacion: "Venta", origen_id: sale.forma_de_pago_id, monto_neto: sale.precio_neto, fecha_operacion: DateTime.now, persona: user.nombre, sale_id: sale.id    
    #actualiza la caja con el dinero ingresado
    Finance.actualizarCaja(sale.forma_de_pago_id, sale.precio_neto)
  end

  def self.accionesVentaPagoParcial sale, user
    Movement.create operacion: sale.copia.producto.nombre, tipo_operacion: "Venta", origen_id: sale.forma_de_pago_id, monto_neto: sale.precio_neto, fecha_operacion: DateTime.now, persona: user.nombre, sale_id: sale.id    
    #quizá actualizar la caja: Finance.actualizarCaja(sale.forma_de_pago_id, sale.precio_neto)
    (sale.cantidad_de_pagos - 1).times do 
      Movement.create operacion: sale.copia.producto.nombre, tipo_operacion: "Venta", sale_id: sale.id, monto_neto: 0.0
    end
  end

  def self.accionesVentaConcretadaPagoParcial sale, user, dolar
    ganancia = Sale.calcularGanancia(sale, dolar)
    dinero_neto = sale.movements.inject(0){|total,m| total + m.monto_neto} #dinero sumado de las x formas de pago
    dinero_bruto = sale.movements.inject(0){|total,m| total + m.monto_bruto} #dinero sumado de las x formas de pago
    sale.update estado: "Concretada", usuario: user, ganancia: ganancia, precio_neto: dinero_neto, precio_bruto: dinero_bruto
    sale.copia.update estado_del_producto: "Vendido"
    #actualizo las cajas en base a los movimientos de la venta
    sale.movements.each do |m|
      Finance.actualizarCaja(m.origen_id, m.monto_neto)
    end
  end

  def self.verificarCambioDeEstado estado_anterior, sale, user
    if estado_anterior == "Cancelada"
      if sale.estado == "Concretada"
        #verificar que la copia ahora ya no esté vendida, si esta vendida dialogo 
        #para ver si queire vender otra o dejar cancelada la venta
        Sale.accionesVentaConcretada(sale, user)
      else # sale.estado == "Pendiente"
        sale.copia.update estado_del_producto: "Reservado"
      end
      OriginSale.actualizarOrigenDeLaVenta(sale.precio_bruto, sale.precio_neto, sale.origin_sale_id)      
    elsif estado_anterior == "Concretada"
      #revertir montos en Finance y Eliminar todos los movements de esa venta
      if sale.estado == "Pendiente"
        #recuperar estado de copy como RESERVADO
        sale.copia.update(estado_del_producto: "Reservado")
      else #sale.estado == "Cancelada"
        #recuperar estado de copy como"En Stock"
        sale.copia.update(estado_del_producto: "En Stock")
        #revertir montos en OriginSale correspondiente
        OriginSale.actualizarOrigenDeLaVenta( (sale.precio_bruto* -1), (sale.precio_neto* -1), sale.origin_sale_id)
      end
      Sale.revertirFinance(sale)
      sale.movements.delete_all #elimino los movimientos
    end
  end

  def self.revertirFinance sale
    #descuenta de la CAJA correspondiente el valor sumado anteriormente
    sale.movements.each do |m|
      Finance.actualizarCaja(m.origen_id, (m.monto_neto* -1))
    end
  end

  def self.verificarCambios sale, modified_sale, user
    #verifica si cambio el estado
    Sale.verificarCambioDeEstado(sale.estado, modified_sale, user) if sale.estado != modified_sale.estado 

    #verifica si cambio el importe
    
    #verifica si cambio el 
  end

  def self.calcularGanancia sale, dolar
    dinero_acumulado =  sale.movements.inject(0) do |total,m|
                           total + m.monto_neto
                        end
    return ((dinero_acumulado / dolar) - sale.copia.precio_compra)
  end


end
