class ImportController < ApplicationController
  before_action :authorize_import

  # GET /import/new
  def new
    @import = Import.new
  end

  def template
    @column_rows = Import::COLUMNS.map do |column|
      keys = column.split('.')
      keys.unshift('internship') if keys.count == 1
      keys.each { |key| key.sub!('_attributes', '') }

      [keys.first(keys.count - 1).map do |key|
        t("activerecord.models.#{key}.one")
      end.join(' / '), t("activerecord.attributes.#{keys.last(2).join('.')}")]
    end.transpose

    respond_to do |format|
      format.xls
    end
  end

  def create
    @import = Import.new(import_params)

    @instances = @import.create
    results = @instances.map do |internship|
      {
          internship: internship.serializable_hash(include: {
              address: {},
              university_supervisor: {},
              enterprise_supervisor: {},
              student: {include: [
                  :address,
                  :user
              ]},
              enterprise: {include: [
                  :address,
                  :director
              ]},
          }),
          errors: internship.errors,
          details: internship.errors.details,
          full_messages: internship.errors.full_messages
      }
    end

    respond_to do |format|
      format.html { render :new, notice: t('helpers.modifications_done') }
      format.json { render json: results, status: :ok }
    end
  end

  private
  def import_params
    # params.require(:import).permit(:spreadsheet, :first_line_different, :lookup)
    params.require(:import).permit! # lookup-hash won't pass?
  end

  def authorize_import
    authorize Import
  end
end