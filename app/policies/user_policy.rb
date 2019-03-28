class UserPolicy < ApplicationPolicy
  def index?
    user.is_a?(Administrator)
  end

  def create?
    user.is_a?(Administrator)
  end
end