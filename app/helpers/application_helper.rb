module ApplicationHelper
  def cotizacion_dolar_blue
    CotizacionDolar.new.blue
  end
  def cotizacion_dolar_libre
    CotizacionDolar.new.libre
  end

######################################
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
