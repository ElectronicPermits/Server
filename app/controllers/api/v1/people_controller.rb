class API::V1::PeopleController < API::V1::AddressableController
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  before_action :set_current_app, only: [:create, :edit, :update, :destroy]
  before_action except: [:show, :index] do
        action = params[:action].upcase
        authenticate_current_app_static(action, "PERSON")
  end

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)
    @person.trusted_app = @current_app

    respond_to do |format|
      if @person.save
        noAddress = params[:address].nil?

        if noAddress || (address = @person.build_address(address_params)).save
          format.json { render action: 'show', status: :created, location: api_v1_person_url(@person) }
        else
          format.json { render json: address.errors, status: :unprocessable_entity }
        end
      else
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update

    respond_to do |format|
      # Optionally update the address, if applicable
      if not params[:address].nil?
        # Create a new one
        if @person.address.nil?
          if not @person.build_address(address_params).save
            format.json { render json: @person.address.errors, status: :unprocessable_entity }
          end
        elsif not @person.address.update(address_params) # or edit the existing
          format.json { render json: @person.address.errors, status: :unprocessable_entity }
        end
      end
    
      # Add/remove vehicle
      if not params[:vehicle].nil? then
          set_vehicle params[:vehicle][:license_plate]
          action = params[:vehicle][:action]
          if action == 'add'
            @person.vehicles << @vehicle
          elsif action == 'remove'
            @person.vehicles.delete(@vehicle)
          else
            format.json { render json: { :error => "Invalid Action" }, status: :unprocessable_entity }
          end
      end

      if params[:person].nil? || @person.update(person_params)
        format.json { head :no_content }
      else
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    if not @person.address.nil?
        @person.address.destroy
    end

    @person.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    def set_vehicle license
      # Vehicles are looked up by license plate number
      @vehicle = Vehicle.where(license_plate: license).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:first_name, :middle_name, :last_name, :date_of_birth, :race, :sex, :height, :weight, :phone_number)
    end

end
