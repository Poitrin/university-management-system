class ProgramDirectorPolicy < UserPolicy
  def index?
     user.is_a?(ProgramDirector) || user.is_a?(Administrator)
  end

  def create?
    user.is_a?(Administrator)
  end
end