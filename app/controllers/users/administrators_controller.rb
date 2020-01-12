class Users::AdministratorsController < UsersController
  before_action :authorize_administrator, only: [:index, :new, :create]

  def index
    @users = Administrator.all
  end

  def new
    @user = Administrator.new
  end

  private
  def authorize_administrator
    authorize Administrator
  end

  def user_params
    # TODO: more secure!
    params.require(:administrator).permit!
  end
end
