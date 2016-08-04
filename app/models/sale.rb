class Sale < ActiveRecord::Base

  # associations
  belongs_to :copia, :class_name => 'Copy', :foreign_key => 'copy_id'
  belongs_to :cliente, :class_name => 'Client', :foreign_key => 'client_id'
  belongs_to :finance, :class_name => 'Finance', :foreign_key => 'finance_id'
  belongs_to :origin_sale, :class_name => 'OriginSale', :foreign_key => 'origin_sale_id'
  belongs_to :forma_de_pago, :class_name => 'Finance', :foreign_key => 'forma_de_pago_id'
  belongs_to :usuario, :class_name => 'User', :foreign_key => 'usuario_id'
  has_many :movements, :class_name => 'Movement', dependent: :destroy

  def self.crearVenta params, copy, user

    #creo nuevo Cliente
    cliente = Client.create nombre: params[:nombre], mail: params[:mail], detalle_adicional: params[:detalle]
    
    #creo la nueva venta
    sale = Sale.create precio_bruto: params[:precio_bruto].to_f, forma_de_pago_id: params[:forma_de_pago_id], copy_id: copy.id, origin_sale_id: params[:origin_sale_id], cliente: cliente, estado: params[:estado], usuario: user, cantidad_de_pagos: params[:cantidad_de_pagos]      
    
    #verifica el estado de la nueva venta y toma las acciones correspondientes  
    if sale.estado == "Pendiente" 
      #realiza las acciones correspondientes para una venta pendiente
      Sale.accionesVentaPendiente(sale, user)
    elsif sale.estado == "Concretada"
      #realiza las acciones correspondientes al concretar una venta
      Sale.accionesVentaConcretada(sale, user)
    else #params[:estado] == "Pago Parcial"
      Sale.accionesVentaPagoParcial(sale, user)
    end
  end

  def self.anularVenta sale
    sale.update estado: "Cancelada"
    sale.copia.update estado_del_producto: "En Stock"
    OriginSale.actualizarOrigenDeLaVenta( (sale.precio_bruto* -1), (sale.precio_neto* -1), sale.origin_sale)
    #verificar
    Sale.revertirFinance(sale)
  end

  def self.accionesVentaConcretada sale, user 
    #actualizo el estado de la copia
    sale.copia.update(estado_del_producto: "Vendido")

    #actualizo el precio neto de la venta
    precio_neto = Sale.calcularPrecioNeto(sale)
    sale.update(precio_neto: precio_neto)
   
    #actualiza montos de origen de la venta (quede pendiente o no, en caso de no ser confirmada se restan)
    OriginSale.actualizarOrigenDeLaVenta(sale.precio_bruto, sale.precio_neto, sale.origin_sale)
    
    #crea un nuevo movimiento
    Movement.create operacion: sale.copia.producto.nombre, tipo_operacion: "Venta", origen_id: sale.forma_de_pago_id, monto_neto: sale.precio_neto, fecha_operacion: DateTime.now, persona: user.nombre, sale_id: sale.id    
    
    #actualizo la ganancia
    ganancia = Sale.calcularGanancia(sale)
    sale.update(ganancia: ganancia)

    #actualiza la caja con el dinero ingresado
    Finance.actualizarCaja(sale.forma_de_pago_id, sale.precio_neto)
  end

  def self.accionesVentaPendiente sale, user
    #actualiza el estado de la copia
    sale.copia.update(estado_del_producto: "Reservado")
    
    #actualiza el precio neto de la venta
    precio_neto = Sale.calcularPrecioNeto(sale)
    sale.update(precio_neto: precio_neto)

    #actualiza el origen de la venta
    OriginSale.actualizarOrigenDeLaVenta(sale.precio_bruto, sale.precio_neto, sale.origin_sale)
  end

  def self.accionesVentaPagoParcial sale, user
    #actualiza el estado de la copia
    sale.copia.update(estado_del_producto: "Reservado")

    #actualizo la forma de pago, en este caso tiene varias, por lo cual forma_de_pago_id es null
    sale.update(forma_de_pago_id: nil)
    
    #quizá actualizar la caja: Finance.actualizarCaja(sale.forma_de_pago_id, sale.precio_neto)
    (sale.cantidad_de_pagos).times do 
      Movement.create operacion: sale.copia.producto.nombre, tipo_operacion: "Venta", sale_id: sale.id, monto_neto: 0.0, sale_id: sale.id
    end
  end

  def self.accionesVentaConcretadaDesdePendiente sale, user
    #actualizo estado de la venta
    sale.update(estado: "Concretada")
    #actualizo el estado de la copia
    sale.copia.update(estado_del_producto: "Vendido")

    #crea un nuevo movimiento
    Movement.create operacion: sale.copia.producto.nombre, tipo_operacion: "Venta", origen_id: sale.forma_de_pago_id, monto_neto: sale.precio_neto, fecha_operacion: DateTime.now, persona: user.nombre+' '+user.apellido, sale_id: sale.id    
    
    #actualizo la ganancia
    ganancia = Sale.calcularGanancia(sale)
    sale.update(ganancia: ganancia)

    #actualiza la caja con el dinero ingresado
    Finance.actualizarCaja(sale.forma_de_pago_id, sale.precio_neto)
  end
  
  def self.accionesVentaConcretadaDesdePagoParcial sale, user
    ganancia = Sale.calcularGanancia(sale)
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

  def self.calcularGanancia sale
    dolar = Option.first.dolar_libre.to_f
    dinero_acumulado =  sale.movements.inject(0) do |total,m|
                           total + m.monto_neto
                        end
    precio_en_dolares = (dinero_acumulado / dolar)
    return (precio_en_dolares - sale.copia.precio_compra.to_f)
  end

  def self.calcularPrecioNeto sale
    if (sale.origin_sale.tipo?) && (sale.forma_de_pago.tipo_mp?) #es Mercadolibre y Mercadopago
      porcentaje_descuento = Option.first.porcentaje_ml_mp
    elsif (sale.origin_sale.tipo?) #es Solo Mercadolibre
      porcentaje_descuento = Option.first.porcentaje_mercadolibre
    elsif (sale.forma_de_pago.tipo_mp?) #es tipo Mercadopago
      porcentaje_descuento = Option.first.porcentaje_mercadopago
    else #no es nada anterior
      return sale.precio_bruto
    end
    descuento = (porcentaje_descuento * sale.precio_bruto)/100
    return (sale.precio_bruto - descuento) 
  end


end
