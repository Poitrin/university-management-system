class StudyProgramPolicy < ApplicationPolicy
  def index?
    user.is_a?(Administrator) || user.is_a?(ProgramDirector)
  end

  def create?
    user.is_a?(Administrator) || user.is_a?(ProgramDirector)
  end
end