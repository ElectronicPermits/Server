# Base functionality for providing rating or service feedback to 
# permits
class API::V1::FeedbackController < ApplicationController

  protected
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


end
