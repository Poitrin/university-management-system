class Users::AdministratorsController < UsersController
  before_action 'authorize Administrator', only: [:index, :new, :create]

  def index
    @users = Administrator.all
  end

  def new
    @user = Administrator.new
  end

  private
  def user_params
    # TODO: more secure!
    params.require(:administrator).permit!
  end
end
