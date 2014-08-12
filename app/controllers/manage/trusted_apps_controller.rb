class Manage::TrustedAppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trusted_app, only: [:show, :edit, :update, :destroy]

  # GET /trusted_apps
  # GET /trusted_apps.json
  def index
    @trusted_apps = TrustedApp.all
  end

  # GET /trusted_apps/1
  # GET /trusted_apps/1.json
  def show
  end

  # GET /trusted_apps/new
  def new
    @trusted_app = TrustedApp.new
  end

  # GET /trusted_apps/1/edit
  def edit
  end

  # POST /trusted_apps
  # POST /trusted_apps.json
  def create
    @trusted_app = TrustedApp.new(trusted_app_params)

    respond_to do |format|
      if @trusted_app.save
        format.html { redirect_to @trusted_app, notice: 'Trusted app was successfully created.' }
        format.json { render action: 'show', status: :created, location: @trusted_app }
      else
        format.html { render action: 'new' }
        format.json { render json: @trusted_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trusted_apps/1
  # PATCH/PUT /trusted_apps/1.json
  def update
    respond_to do |format|
      if @trusted_app.update(trusted_app_params)
        format.html { redirect_to @trusted_app, notice: 'Trusted app was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @trusted_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trusted_apps/1
  # DELETE /trusted_apps/1.json
  def destroy
    @trusted_app.destroy
    respond_to do |format|
      format.html { redirect_to trusted_apps_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trusted_app
      @trusted_app = TrustedApp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trusted_app_params
      params.require(:trusted_app).permit(:app_name, :description, :sha_hash)
    end
end
