class EnterprisesController < ApplicationController
  before_action :set_enterprise, only: [:show, :edit, :update, :destroy]
  before_action :authorize_enterprise, only: [:index, :create, :new]

  def index
    @enterprises = Enterprise.includes([:internships, address: [:country]])
    @enterprises = policy_scope(@enterprises)
    @enterprises = @enterprises.order(:name)

    @enterprises = @enterprises.normalized_name(params[:name]) unless params[:name].blank?
    @enterprises = @enterprises.country_id(params[:country_id]) unless params[:country_id].blank?

    @enterprises = @enterprises.page params[:page]

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @enterprises }
    end
  end

  def show
  end

  def new
    @enterprise = Enterprise.new
  end

  def edit
  end

  def create
    @enterprise = Enterprise.new(enterprise_params)
    @enterprise.created_by = current_user

    respond_to do |format|
      if @enterprise.save
        format.html { redirect_to @enterprise, notice: t('helpers.modifications_done') }
        format.json { render :show, status: :created, location: @enterprise }
      else
        format.html { render :new }
        format.json { render json: {errors: @enterprise.errors}, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @enterprise.update(enterprise_params)
        format.html { redirect_to @enterprise, notice: t('helpers.modifications_done') }
        format.json { render :show, status: :ok, location: @enterprise }
      else
        format.html { render :edit }
        format.json { render json: @enterprise.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # TODO: This redirects even when a error occured!
    if @enterprise.destroy
      hash = { notice: t('helpers.modifications_done') }
    end

    respond_to do |format|
      format.html { redirect_to enterprises_url, hash }
      format.json { head :no_content }
    end
  end

  private
  def set_enterprise
    @enterprise = Enterprise.find(params[:id])
    authorize @enterprise
  end

  def enterprise_params
    params.require(:enterprise).permit! # TODO: find a better solution...
  end

  def authorize_enterprise
    authorize Enterprise
  end
end