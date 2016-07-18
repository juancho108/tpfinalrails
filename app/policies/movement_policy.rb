class MovementPolicy < ApplicationPolicy
    def index?
      user.admin? or user.publicador?
    end

    def show?
      user.admin? or user.publicador?
    end

    def create?
      user.admin? or user.publicador?
    end

    def new?
      user.admin? or user.publicador?
    end

    def update?
      user.admin? or user.publicador?
    end

    def edit?
      user.admin? or user.publicador?
    end

    def destroy?
      user.admin? or user.publicador?
    end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
