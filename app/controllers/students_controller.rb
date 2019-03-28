class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :authorize_student, only: [:index, :new, :create]
  # TODO: can you delete yourself?
  # TODO: can a Student delete another student?

  def index
    @students = Student.all

    @students = policy_scope(@students)

    @students = @students.full_name(params[:term]) unless params[:term].blank?
    @students = @students.study_program_id(params[:study_program_id]) unless params[:study_program_id].blank?
    @students = @students.degree(params[:degree]) unless params[:degree].blank?
    @students = @students.promotion(params[:promotion]) unless params[:promotion].blank?
    @students = @students.page params[:page]

    @students = @students.order(:surname, :first_name, :id)

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @students }
    end
  end

  def show
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: t('helpers.modifications_done') }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: {errors: @student.errors}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: t('helpers.modifications_done') }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    if @student.destroy
      hash = {notice: t('helpers.modifications_done')}
    else
      hash = {alert: t('students.destroy.delete_internships_first')}
    end

    respond_to do |format|
      format.html { redirect_to students_url, hash }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student
      .includes([
        diplomas: [:study_program],
        address: [:country],
        internships: []
      ])
      .find(params[:id])
    authorize @student
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    # TODO: change!
    # params.require(:person).permit(:title_id, :first_name, :last_name, :birth_name, :complete_name, :birth_date)
    params.require(:student).permit!
  end

  def authorize_student
    authorize Student
  end
end
