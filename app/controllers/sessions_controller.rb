class SessionsController < ApplicationController
  def create
    skip_authorization

    @session = Session.new(session_params)

    respond_to do |format|
      if @session.valid?
        token = @session.person.token
        format.html {
          session[:token] = token
          redirect_to root_path
        }
        format.json { render json: {token: token} }
      else
        if @session.errors.details[:password].present?
          status = @session.errors.details[:password].first[:error] == :invalid ? :unauthorized : :unprocessable_entity
        else
          status = :unprocessable_entity
        end

        format.html { render 'homepage/index' }
        format.json { render json: {errors: @session.errors}, status: status }
      end
    end
  end

  def destroy
    skip_authorization # TODO: or find a way with authorize?

    current_user.update(token: nil) if current_user
    session.delete(:token)

    respond_to do |format|
      format.html { redirect_to root_url, notice: t('.logged_out') }
      format.json
    end
  end

  private
  def session_params
    params.require(:session).permit(:user_name, :password, :forgot_password)
  end
end
