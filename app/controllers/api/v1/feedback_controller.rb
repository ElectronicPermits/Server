# Base functionality for providing rating or service feedback to 
# permits
class API::V1::FeedbackController < API::V1::BaseController

  protected
    def build_consumer
      set_current_app
      @consumer = nil

      #@current_app = TrustedApp.where(:sha_hash => params[:app_signature]).first
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
      end

    end

    def set_permit
      beacon_id = params[:permit_beacon_id]
      permit_number = params[:permit_number]
      if not beacon_id.nil? then
        @permit = Permit.where(:beacon_id => beacon_id).first
      elsif not permit_number.nil? then
        @permit = Permit.where(:permit_number => permit_number).first
      end
    end


end
