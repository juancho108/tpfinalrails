class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized  
#####################################################



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:nombre, :apellido, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:nombre, :apellido, :email, :password, :remember_me) }
  end

  private

  def user_not_authorized
    flash[:alert] = "Usted no tiene permisos para hacer esta accion"
    redirect_to(request.referrer || root_path)
  end
end
