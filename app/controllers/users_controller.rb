class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # before_action 'authorize User', only: [:index, :new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  # def show
  #   redirect_to polymorphic_path(@user.class)
  # end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to polymorphic_path([:users, @user.class]), notice: t('helpers.modifications_done') }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        # TODO: user.update only for password recovery?
        format.html { redirect_to polymorphic_path([:users, @user.class]), notice: t('helpers.modifications_done') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to polymorphic_path([:users, @user.class]), notice: t('helpers.modifications_done') }
      format.json { head :no_content }
    end
  end

  private
  def user_params
    # TODO: more secure!
    params.require(:user).permit!
  end

  def set_user
    @user = User.find(params[:id])
    @user.old_password = params[:old_password] if @user.old_password.blank?
    authorize @user
  end

  # A) The administrator wants to edit a user.
  # B) The user forgot their password, and clicked on the link in the "recovery mail".
  # def require_admin_or_digest
  #   if !current_user.is_a?(Administrator) and (@user.password_digest != params[:old_password])
  #     require_admin_rights
  #   end
  # end
end
