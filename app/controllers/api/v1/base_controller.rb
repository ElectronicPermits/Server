class API::V1::BaseController < ApplicationController
  #Add app access control logic
  
  #Base api controller
  #contains app authentication
  def set_current_app
    signature = params[:app_signature]
    if not signature.nil?
      sha_hash = Digest::SHA1.hexdigest(signature)
      @current_app = TrustedApp.where(:sha_hash => sha_hash).first
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

    # set service type
    @service_type = @permit.service_type

  end

  def authenticate_current_app(action)
    if not trusted_app_can(action, @service_type.id) then
      respond_to do |format|
        format.json { render json: { :error => "Access Denied" }, status: :forbidden }
      end
      return
    end
  end

end
