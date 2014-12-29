# Base functionality for providing rating or service feedback to 
# permits
class API::V1::FeedbackController < API::V1::BaseController
  #before_action :set_current_app, only: [:build_consumer]

  protected
    def build_consumer
      @consumer = nil
      set_current_app

      if not @current_app.nil? then
        uuid = params[:consumer_id]
        @consumer = @current_app.consumers.where(:unique_user_id => uuid).first

        if @consumer.nil? then

          @consumer = Consumer.new(:unique_user_id => uuid)
          @consumer.trusted_app = @current_app

          if not @consumer.save then
            @consumer = nil
          end
        end

        if @consumer.nil? then
            respond_to do |format|
                format.json { render json: { :error => "Application lacks permissions" }, status: :forbidden }
            end
        end
      end
    end

end
