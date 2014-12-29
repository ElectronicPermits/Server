class API::V1::ServiceTypesController < API::V1::BaseController
  before_action :set_service_type, only: [:show, :edit, :update, :destroy]
  before_action :set_current_app, only: [:create, :edit, :update, :destroy]
  before_action except: [:show, :index] do
        action = params[:action].upcase
        authenticate_current_app_static(action, "SERVICE_TYPE")
  end

  # GET /service_types
  # GET /service_types.json
  def index
    @service_types = ServiceType.all
  end

  # GET /service_types/1
  # GET /service_types/1.json
  def show
  end

  # GET /service_types/new
  def new
    @service_type = ServiceType.new
  end

  # GET /service_types/1/edit
  def edit
  end

  # POST /service_types
  # POST /service_types.json
  def create
    @service_type = ServiceType.new(service_type_params)
    @service_type.trusted_app = @current_app

    #Create associated permissions
    #For each element in PERMISSION_TYPES
      #Create a permission bound to the given service type
    #Should I add a method that does this for me in the model? 
    #Should this functionality be put somewhere else?
    #
    #For now I may require the service types to be explicitly created
    # (alternatively, they could be made on the fly)
    total_saved_permissions = 0

    Permission.permission_types.each do |perm_key, permission_type|
    #@service_type.build_permission(:permission_type => permission_type)
      permission = Permission.new
      permission.service_type = @service_type
      permission.permission_type = permission_type
      if permission.save
        total_saved_permissions += 1
      end
    end

    respond_to do |format|
      if @service_type.save
        format.json { render action: 'show', status: :created, location: @service_type }
      else
        format.json { render json: @service_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_types/1
  # PATCH/PUT /service_types/1.json
  def update
    respond_to do |format|
      if @service_type.update(service_type_params)
        format.json { head :no_content }
      else
        format.json { render json: @service_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_types/1
  # DELETE /service_types/1.json
  def destroy
    # First, see if the current app has the correct permissions

    # Next, remove all associated permission types
    if not @service_type.nil?
      permissions = @service_type.permissions
      permissions.each do |p|
        p.destroy
      end
    end

    @service_type.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_type
      @service_type = ServiceType.where(name: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_type_params
      params.require(:service_type).permit(:name, :description)
    end
end
