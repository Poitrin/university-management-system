class Users::ProgramDirectorsController < UsersController
  before_action 'authorize ProgramDirector', only: [:index, :new, :create]

  def index
    @users = ProgramDirector.all
  end

  def new
    @user = ProgramDirector.new
  end

  private
  def user_params
    # TODO: more secure!
    params.require(:program_director).permit!
  end
end
