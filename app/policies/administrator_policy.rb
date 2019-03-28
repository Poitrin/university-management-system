class AdministratorPolicy < ApplicationPolicy
  def index?
    user.is_a?(Administrator)
  end

  def create?
    user.is_a?(Administrator)
  end

  def destroy?
    # Administrator can not delete himself
    super && (user.id != record.id)
  end
end