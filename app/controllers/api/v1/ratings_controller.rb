class API::V1::RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  before_action :build_consumer, only: [:create]

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

    #Update the average rating/total ratings of corresponding permit
    
    #@consumer = Consumer.where(:uuid => @rating.consumer_id).first

    @rating.consumer = @consumer

    # Create the ride if provided
    #if not ride_params[:start_latitude].nil?
        #puts "RIDE PARAMS: #{ride_params}"
        #ride = Ride.new(ride_params)
        #ride.consumer_id = @consumer.id
        #ride.save
    #end

    # Check the amount of recent ratings 
    if @rating.consumer.ratings.where(:created_at => 24.hours.ago..Time.now).to_a.length < @rating.trusted_app.max_daily_posts

      # Adjust the given permit's meta data
      @permit = @rating.permit 
      @permit.average_rating = (@permit.average_rating * @permit.total_ratings + @rating.rating)/(@permit.total_ratings + 1)
      @permit.total_ratings +=  1
      @permit.save

      # Link rating to ride
      #@rating.ride_id = ride.nil? ? nil : ride.id

      respond_to do |format|
        if @rating.save
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
        format.json { render json: { :error => "Too many recent requests" }, status: :unprocessable_entity }
      end
      #Add logger here
      #TODO
    end
 
    respond_to do |format|
      if @rating.save
        format.html { redirect_to @rating, notice: 'Rating was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rating }
      else
        format.html { render action: 'new' }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
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

      if @consumer.nil?
        #TODO Get the app signature hash!
        sha_hash = params[:app_signature]

        @consumer = Consumer.new(:unique_user_id => @rating.consumer_id)
        @consumer.trusted_app = TrustedApp.where(:sha_hash => sha_hash)
        if @consumer.save then
          format.json { render json: @consumer.errors, status: :unprocessable_entity } #Change this to a custom message TODO
        end
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:rating, :comments)
    end
end
