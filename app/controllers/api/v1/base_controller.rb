class API::V1::BaseController < ApplicationController
  #Add app access control logic
  #May need to go in a different file...
  #TODO
  
  #Base api controller
  #contains app authentication
  def set_current_app
    signature = params[:app_signature]
    if not signature.nil?
      sha_hash = Digest::SHA1.hexdigest(signature)
      @current_app = TrustedApp.where(:sha_hash => sha_hash).first
    end
  end
end
