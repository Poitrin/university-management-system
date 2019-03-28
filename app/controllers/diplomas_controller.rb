class DiplomasController < ApplicationController
  before_action :set_diploma, only: [:destroy]

  def destroy
    student = @diploma.student
    @diploma.destroy
    respond_to do |format|
      format.html { redirect_to edit_student_path(student), notice: t('helpers.modifications_done') }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_diploma
    @diploma = Diploma.find(params[:id])
    authorize @diploma
  end
end
