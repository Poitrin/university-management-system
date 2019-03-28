class StudentPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  def index?
    user.present?
  end

  def show?
    user_owns_profile or super
  end

  private
  def user_owns_profile
    user.id == record.id
  end
end