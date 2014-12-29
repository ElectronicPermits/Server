class API::V1::VehiclesController < API::V1::BaseController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
  before_action :set_current_app, only: [:create, :edit, :update, :destroy]
  before_action except: [:show, :index] do
        action = params[:action].upcase
        authenticate_current_app_static(action, "VEHICLE")
  end

  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = Vehicle.all
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.trusted_app = @current_app

    respond_to do |format|
      if @vehicle.save
        format.json { render action: 'show', status: :created, location: @vehicle }
      else
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.json { head :no_content }
      else
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    puts "DELETE? #{params[:action]}"
    @vehicle.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      # Vehicles are looked up by license plate number
      @vehicle = Vehicle.where(license_plate: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit(:make, :model, :color, :year, :inspection_date, :license_plate)
    end

end
