class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery # Prevent CSRF attacks by raising an exception. For APIs, you may want to use :null_session instead.

  before_action :set_locale
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def set_locale
    # I18n.locale = params[:locale] || I18n.default_locale
    # TODO: pass via default_locale ?
    I18n.locale = params[:locale] || extract_locale_from_header
  end

  def default_url_options(options={})
    # logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  private
  def extract_locale_from_header
    accept_language = request.env['HTTP_ACCEPT_LANGUAGE']

    if accept_language
      locale = accept_language[0..1].downcase
      return locale if %w(de fr).include?(locale)
    end

    'en'
  end

  def current_user
    received_token = nil

    if session[:token]
      # token has been transferred via Cookie
      received_token = session[:token]
    elsif params[:token]
      received_token = params[:token]
      session[:token] = received_token # save token to session
    else
      # token has been transferred via Authorization Token Header
      authenticate_with_http_token { |token, options| received_token = token }
    end

    @current_user ||= Person.find_by_token(received_token) if received_token
  end

  def current_admin
    # TODO: check if there is not a better way
    @current_user if current_user.instance_of? Administrator
  end

  def current_program_director
    @current_user if current_user.instance_of? ProgramDirector
  end

  def current_person
    @current_person ||= current_user.person
  end

  def current_student
    @current_student ||= current_person if current_person.instance_of? Student
  end

  def user_not_authorized
    respond_to do |format|
      format.html {
        flash[:alert] = t('layouts.application.you_can_not_access_this_content')
        redirect_to(request.referrer || root_path)
      }
      format.json {
        head :unauthorized
      }
    end
  end

  helper_method :current_user
  helper_method :current_admin
  helper_method :current_person
  helper_method :current_student
end
