class InternshipsController < ApplicationController
  before_action :set_internship, only: [:show, :edit, :update, :authorize_internship, :validate, :destroy]
  before_action :auth_internship, only: [:index, :new, :create]

  def index
    @internships = policy_scope(Internship.all).order(:start_date)

    @internships = @internships.study_program_id(params[:study_program_id]) unless params[:study_program_id].blank?
    @internships = @internships.lang_id(params[:lang_id]) unless params[:lang_id].blank?
    @internships = @internships.year(params[:year]) unless params[:year].blank?

    @internships = @internships.page params[:page]
  end

  def show
  end

  def new
    @internship = Internship.new(enterprise_id: params[:enterprise], student_id: params[:student])
  end

  def edit
  end

  def create
    @internship = Internship.new(internship_params)

    respond_to do |format|
      if @internship.save
        format.html { redirect_to @internship, notice: t('helpers.modifications_done') }
        format.json { render :show, status: :created, location: @internship }
      else
        format.html { render :new }
        format.json { render json: {errors: @internship.errors}, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @internship.update(internship_params)
        format.html { redirect_to @internship, notice: t('helpers.modifications_done') }
        # format.json { render :show, status: :ok, location: @internship }
      else
        format.html { render :edit }
        # format.json { render json: @internship.errors, status: :unprocessable_entity }
      end
    end
  end



  # Note: authorize has been taken by Pundit
  def authorize_internship
    respond_to do |format|
      if @internship.update(authorized: params[:authorized],
                            authorization_date: Date.today,
                            authorization_reasons: internship_params[:authorization_reasons],
                            authorized_by: current_program_director)
        format.html { redirect_to @internship }
      else
        format.html { render :show }
      end
    end
  end

  def validate
    respond_to do |format|
      if @internship.update(validated: params[:validated],
                            validation_date: Date.today,
                            validation_reasons: internship_params[:validation_reasons],
                            validated_by: current_program_director)
        format.html { redirect_to @internship }
      else
        format.html { render :show }
      end
    end
  end

  def destroy
    @internship.destroy
    respond_to do |format|
      format.html { redirect_to internships_url, notice: t('helpers.modifications_done') }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_internship
    @internship = Internship.find(params[:id])
    authorize @internship
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def internship_params
    # TODO: change!
    # params.require(:internship).permit(:student_id, :study_program_id, :degree, :enterprise_id, :start_date, :end_date, :project_description, :project_confidential, :working_days_per_week, :working_hours_per_week, :internship_origin, :university_supervisor_id, :university_validated, :university_validation_date, :enterprise_supervisor_id, :enterprise_validated, :enterprise_validation_date, :payment_per_month, :lang_id, :department, :internship_address_id)
    internship = params.require(:internship).permit!
  end

  def current_creator
    # user must be logged in, must be student, and be the "creator" of @internship
    current_student if (current_student and current_student.id == @internship.student.id)
  end

  def auth_internship
    authorize Internship
  end

  helper_method :current_creator
  helper_method :current_program_director
end
