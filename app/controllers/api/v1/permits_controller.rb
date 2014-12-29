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
        format.json { render action: 'show', status: :created, location: api_v1_permit_url(@permit) }
      else
        format.json { render json: @permit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permits/1
  # PATCH/PUT /permits/1.json
  def update
    @permit.permitable = permitable 
    respond_to do |format|
      if @permit.update(permit_params)
        format.json { head :no_content }
      else
        format.json { render json: @permit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permits/1
  # DELETE /permits/1.json
  def destroy
    @permit.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permit # Use beacon id if we have one
      @permit = Permit.where(:beacon_id => params[:id]).first

      # Set service_type for authentication via API
      @service_type = @permit.service_type
    end

    # This is required for access control when creating a new permit
    def set_service_type
        service_type_name = params[:service_type]
        @service_type = ServiceType.where(name: service_type_name).first

        if @service_type.nil? then
            # Cannot create a permit without a service type. Return error
            respond_to do |format|
                format.json { render json: { :error => "Invalid Service Type" }, 
                              :status => :unprocessable_entity }
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
        perm = nil

        if not params[:company].nil? then # company name
          result = Company.where(name: params[:company][:name]).first

          if result.nil? then
            perm = Company.new(company_params)
          end

        elsif not params[:person].nil? then # id
          result = Person.where(id: params[:person][:id]).first

          if result.nil? then
            perm = Person.new(person_params)
          end

        elsif not params[:vehicle].nil? then # license_plate
          result = Vehicle.where(license_plate: params[:vehicle][:license_plate]).first

          if result.nil? then
            perm = Vehicle.new(vehicle_params)
          end
        end

        if perm.nil? or perm.save then
            return result || perm
        else
          respond_to do |format|
            format.json { render json: perm.errors, status: :unprocessable_entity }
          end
        end
    end

    # Permitable types filter
    def company_params
      params.require(:company).permit(:name, :average_rating, :phone_number)
    end

    def person_params
      params.require(:person).permit(:first_name, :middle_name, :last_name, :date_of_birth, :race, :sex, :height, :weight, :phone_number)
    end

    def vehicle_params
      params.require(:vehicle).permit(:make, :model, :color, :year, :inspection_date, :license_plate)
    end
end
