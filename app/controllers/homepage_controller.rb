class HomepageController < ApplicationController
  def index
    skip_authorization
    skip_policy_scope

    if current_user
      redirect_to students_path
    else
      @session = Session.new
    end
  end
end
