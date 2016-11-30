module ApplicationHelper
  def cotizacion_dolar_blue
    Option.instance.dolar_blue
  end
  def cotizacion_dolar_libre
    Option.instance.dolar_libre
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
