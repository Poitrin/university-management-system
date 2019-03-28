class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user

    @user = user
    @record = record
  end

  # index = show
  def index?
    user.administrator?
  end


  def show?
    user.administrator?
  end

  # create = update = destroy
  def create?
    user.administrator?
  end

  def new?
    create?
  end


  def update?
    create?
  end

  def edit?
    update?
  end


  def destroy?
    create?
  end
end

