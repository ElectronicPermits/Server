class API::V1::RatingsController < API::V1::FeedbackController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  before_action :build_consumer, only: [:create]
  before_action :set_permit, only: [:create]

  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = Rating.all
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  # GET /ratings/1/edit
  def edit
  end

  # POST /ratings
  # POST /ratings.json
  def create
    #Add authentication of app (make sure it is a trusted app with correct permissions)
    #TODO
    @rating = Rating.new(rating_params)

    @rating.consumer = @consumer
    @rating.permit = @permit

    # Create the ride if provided
    #if not ride_params[:start_latitude].nil?
        #puts "RIDE PARAMS: #{ride_params}"
        #ride = Ride.new(ride_params)
        #ride.consumer_id = @consumer.id
        #ride.save
    #end

    # Check the amount of recent ratings 
    if @consumer.ratings.where(:created_at => 24.hours.ago..Time.now).to_a.length < @consumer.trusted_app.max_daily_posts

      respond_to do |format|
        if @rating.save
          #Update the rating info
          adjust_permit_average_rating

          format.json { render action: 'show', status: :created, location: @rating }
          #if not ride.nil?
            #ride.rating_id = @rating.id
            #ride.save
          #end
        else
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json: { :error => "Too many recent requests" }, status: :locked }
      end
    end
  end

  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to @rating, notice: 'Rating was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to ratings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    def build_consumer
      uuid = params[:consumer_id]
      @consumer = Consumer.where(:unique_user_id => uuid).first

      if @consumer.nil? then
        #TODO Get the app signature hash!
        sha_hash = params[:app_signature]

        trusted_app = TrustedApp.where(:sha_hash => sha_hash).first
        @consumer = Consumer.new(:unique_user_id => uuid)
        @consumer.trusted_app = trusted_app

        if not @consumer.save then
          @consumer = nil
        end
      end

    end

    def set_permit
      beacon_id = params[:permit_beacon_id]
      @permit = Permit.where(:beacon_id => beacon_id).first
    end

    def adjust_permit_average_rating
      # Adjust the given permit's meta data
      @permit.average_rating = (@permit.average_rating * @permit.total_ratings + @rating.rating)/(@permit.total_ratings + 1)
      @permit.total_ratings +=  1
      @permit.save
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:rating, :comments)
    end

end
