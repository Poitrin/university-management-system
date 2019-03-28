class EnterprisePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    record.internships.exists?(student_id: user.id) or super
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if @user.administrator?
        scope.all
      else
        scope.all.where(internships: {student_id: user.id})
      end
    end
  end
end