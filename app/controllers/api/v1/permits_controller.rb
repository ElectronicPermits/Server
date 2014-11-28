class API::V1::PermitsController < API::V1::BaseController
  before_action :set_permit, only: [:show, :edit, :update, :destroy]
  before_action :set_service_type, only: [:create] # Required for access control
  before_action :set_current_app, only: [:create, :edit, :update, :destroy]
  before_action only: [:create, :update, :edit] do
      authenticate_current_app(Permission.permission_types[:MANAGE_PERMITS])
  end

  # GET /permits
  # GET /permits.json
  def index
    @permits = Permit.all
  end

  # GET /permits/1
  # GET /permits/1.json
  def show
  end

  # GET /permits/new
  def new
    @permit = Permit.new
  end

  # GET /permits/1/edit
  def edit
  end

  # POST /permits
  # POST /permits.json
  def create
    @permit = Permit.new(permit_params)
    @permit.service_type = @service_type
    @permit.trusted_app = @current_app

    # Determine the permitable object
    @permit.permitable = permitable

    respond_to do |format|
      if @permit.save
        format.html { redirect_to @permit, notice: 'Permit was successfully created.' }
        format.json { render action: 'show', status: :created, location: @permit }
      else
        format.html { render action: 'new' }
        format.json { render json: @permit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permits/1
  # PATCH/PUT /permits/1.json
  def update
    respond_to do |format|
      if @permit.update(permit_params)
        format.html { redirect_to @permit, notice: 'Permit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @permit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permits/1
  # DELETE /permits/1.json
  def destroy
    @permit.destroy
    respond_to do |format|
      format.html { redirect_to permits_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permit # Use beacon id if we have one
      if params[:id].nil?
        @permit = Permit.where(:beacon_id => params[:beacon_id]).first
      else
        @permit = Permit.find(params[:id])
      end
    end

    # This is required for access control when creating a new permit
    def set_service_type
        service_type_name = params[:service_type]
        @service_type = ServiceType.where(name: service_type_name).first

        if @service_type.nil? then
            # Cannot create a permit without a service type. Return error
            respond_to do |format|
                format.json { render json: { :error => "Bad Service Type" }, :status => :bad_request }
            end
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permit_params
      params.require(:permit).permit(:permit_number, :permit_expiration_date, :training_completion_date, :status, :valid, :beacon_id)
    end

    # Get the permitable item when creating permit
    def permitable
        result = nil

        if not params[:company].nil? then # company name
          result = Company.where(name: params[:company]).first
        elsif not params[:person].nil? then # id
          result = Person.where(id: params[:person]).first
        elsif not params[:vehicle].nil? then # license_plate
          result = Vehicle.where(license_plate: params[:vehicle]).first
        end

        return result
    end
end
