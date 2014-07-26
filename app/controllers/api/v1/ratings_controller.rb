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

    # Check the amount of recent ratings 
    if @consumer.nil? then

      respond_to do |format|
        format.json { render json: { :error => "Application lacks permissions" }, status: :forbidden }
      end
      
    elsif @consumer.ratings.where(:created_at => 24.hours.ago..Time.now).to_a.length < @consumer.trusted_app.max_daily_posts

      respond_to do |format|
        if @rating.save
          #Update the rating info
          adjust_permit_average_rating

          format.json { render action: 'show', status: :created, location: @rating }
        else
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json: { :error => "Too many recent requests" }, status: :too_many_requests }
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

    def adjust_permit_average_rating
      # Adjust the given permit's meta data
      if @permit.total_ratings == @permit.ratings.count-1 then
        @permit.average_rating = (@permit.average_rating * @permit.total_ratings + @rating.rating)/(@permit.total_ratings + 1)
        @permit.total_ratings += 1
      elsif #assume corrupted data. Recalculate the permit's rating
        sum = 0
        @permit.total_ratings = 0

        @permit.ratings.each do |r|
          sum += r.rating
          @permit.total_ratings += 1
        end
        @permit.average_rating = sum/@permit.total_ratings
      end

      @permit.save

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:rating, :comments)
    end

end
