class OptionPolicy < ApplicationPolicy
  	
	def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def create?
    user.admin? 
  end

  def new?
    user.admin? 
  end

  def update?
    user.admin? 
  end

  def edit?
    user.admin?
  end

  def destroy?
    user.admin? 
  end

  def resetear_cuentas_ml?
    user.admin?
  end

  def actualizar_valor_dolar?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
