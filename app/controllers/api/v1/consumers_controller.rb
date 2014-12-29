class API::V1::ConsumersController < API::V1::BaseController
  before_action :set_consumer, only: [:show, :edit, :update, :destroy]
  before_action :set_current_app, only: [:create]

  # GET /consumers
  # GET /consumers.json
  def index
    @consumers = Consumer.all
  end

  # GET /consumers/1
  # GET /consumers/1.json
  def show
  end

  # GET /consumers/new
  def new
    @consumer = Consumer.new
  end

  # GET /consumers/1/edit
  def edit
  end

  # POST /consumers
  # POST /consumers.json
  def create
    @consumer = Consumer.new(consumer_params)
    @consumer.trusted_app = @trusted_app

    respond_to do |format|
      if @consumer.save
        format.json { render action: 'show', status: :created, location: api_v1_consumer_url(@consumer) }
      else
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consumers/1
  # PATCH/PUT /consumers/1.json
  def update
    respond_to do |format|
      if @consumer.update(consumer_params)
        format.json { head :no_content }
      else
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumers/1
  # DELETE /consumers/1.json
  def destroy
    @consumer.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consumer
      @consumer = Consumer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consumer_params
      params.require(:consumer).permit(:unique_user_id)
    end

end
