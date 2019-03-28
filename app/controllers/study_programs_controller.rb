class StudyProgramsController < ApplicationController
  before_action :set_study_program, only: [:show, :edit, :update, :destroy]
  before_action :authorize_study_program, only: [:index, :new, :create]

  # GET /study_programs
  # GET /study_programs.json
  def index
    @study_programs = StudyProgram.all
  end

  # GET /study_programs/1
  # GET /study_programs/1.json
  def show
  end

  # GET /study_programs/new
  # def new
  #   @study_program = StudyProgram.new
  # end

  # GET /study_programs/1/edit
  def edit
  end

  # POST /study_programs
  # POST /study_programs.json
  # def create
  #   @study_program = StudyProgram.new(study_program_params)
  #
  #   respond_to do |format|
  #     if @study_program.save
  #       format.html { redirect_to @study_program, notice: 'Study program was successfully created.' }
  #       format.json { render :show, status: :created, location: @study_program }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @study_program.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /study_programs/1
  # PATCH/PUT /study_programs/1.json
  def update
    respond_to do |format|
      if @study_program.update(study_program_params)
        format.html { redirect_to study_programs_path, notice: t('helpers.modifications_done') }
        # format.json { render :show, status: :ok, location: @study_program }
      else
        format.html { render :edit }
        # format.json { render json: @study_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /study_programs/1
  # DELETE /study_programs/1.json
  def destroy
    @study_program.destroy
    respond_to do |format|
      format.html { redirect_to study_programs_url, notice: 'Study program was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_study_program
    @study_program = StudyProgram.find(params[:id])
    authorize @study_program
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def study_program_params
    params.require(:study_program).permit! # TODO: change!
  end

  def authorize_study_program
    authorize StudyProgram
  end
end
