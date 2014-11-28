class API::V1::PermitsController < API::V1::BaseController
  before_action :set_permit, only: [:show, :edit, :update, :destroy]
  before_action :set_current_app, only: [:create, :edit, :update, :destroy]

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

    # Never trust parameters from the scary internet, only allow the white list through.
    def permit_params
      params.require(:permit).permit(:permit_number, :permit_expiration_date, :training_completion_date, :status, :valid, :beacon_id)
    end
end
