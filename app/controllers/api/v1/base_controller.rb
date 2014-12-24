class API::V1::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
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
    if @permit.nil? then
      respond_to do |format|
        format.json { render json: { :error => "Permit Not Found" }, status: :unprocessable_entity }
      end
    else
      @service_type = @permit.service_type
    end

  end

  def authenticate_current_app_static(action, target)
    if not trusted_app_can_static(action, target) then
      respond_to do |format|
        format.json { render json: { :error => "Access Denied" }, status: :forbidden }
      end
    end
  end

  def authenticate_current_app(action)
    if not trusted_app_can(action, @service_type.id) then
      respond_to do |format|
        format.json { render json: { :error => "Access Denied" }, status: :forbidden }
      end
    end
  end

end
