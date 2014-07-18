class AppRolesController < ApplicationController
  before_action :set_app_role, only: [:show, :edit, :update, :destroy]

  # GET /app_roles
  # GET /app_roles.json
  def index
    @app_roles = AppRole.all
  end

  # GET /app_roles/1
  # GET /app_roles/1.json
  def show
  end

  # GET /app_roles/new
  def new
    @app_role = AppRole.new
  end

  # GET /app_roles/1/edit
  def edit
  end

  # POST /app_roles
  # POST /app_roles.json
  def create
    @app_role = AppRole.new(app_role_params)

    respond_to do |format|
      if @app_role.save
        format.html { redirect_to @app_role, notice: 'App role was successfully created.' }
        format.json { render action: 'show', status: :created, location: @app_role }
      else
        format.html { render action: 'new' }
        format.json { render json: @app_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_roles/1
  # PATCH/PUT /app_roles/1.json
  def update
    respond_to do |format|
      if @app_role.update(app_role_params)
        format.html { redirect_to @app_role, notice: 'App role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @app_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_roles/1
  # DELETE /app_roles/1.json
  def destroy
    @app_role.destroy
    respond_to do |format|
      format.html { redirect_to app_roles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_role
      @app_role = AppRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_role_params
      params.require(:app_role).permit(:name, :description)
    end
end
