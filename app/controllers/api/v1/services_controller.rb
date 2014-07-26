class API::V1::ServicesController < API::V1::FeedbackController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :build_consumer, only: [:create]
  before_action :set_permit, only: [:create]

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    @service.permit = @permit
    @service.consumer = @consumer

    if @consumer.nil? then

      respond_to do |format|
        format.json { render json: { :error => "Application lacks permissions" }, status: :forbidden }
      end
      
    elsif @consumer.services.where(:created_at => 24.hours.ago..Time.now).to_a.length < @consumer.trusted_app.max_daily_posts

      respond_to do |format|
        if @service.save
          #Update the service info
          adjust_permit_average_service

          format.json { render action: 'show', status: :created, location: @service }
        else
          format.json { render json: @service.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json: { :error => "Too many recent requests" }, status: :too_many_requests }
      end
    end

  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:start_coordinates, :end_coordinates, :start_time, :end_time, :estimated_cost, :actual_cost)
    end
end
