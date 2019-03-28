class InternshipPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.administrator?
        scope.all
      else
        scope.where(student_id: user.id)
      end
    end
  end

  def create?
    @user.administrator?
  end

  def index?
    user.present?
  end

  def show?
    user_does_internship or super
  end

  def authorize_internship?
    # program directors can only validate the internships of their study program
    # @user.is_a?(ProgramDirector) && @record.study_program_id == @user.study_program_id
    @user.administrator?
  end

  def validate?
    authorize_internship?
  end

  private
  def user_does_internship
    user.id == record.student_id
  end
end