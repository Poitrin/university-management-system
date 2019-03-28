class ImportPolicy < ApplicationPolicy
  def index?
    user.is_a?(Administrator) || user.is_a?(ProgramDirector)
  end

  def create?
    user.is_a?(Administrator) || user.is_a?(ProgramDirector)
  end

  def template?
    new?
  end
end

