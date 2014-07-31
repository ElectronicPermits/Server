class API::V1::BaseController < ApplicationController
  #Base api controller
  #contains app authentication
  def set_current_app
    signature = params[:app_signature]
    # TODO decrypt
    sha_hash = signature
    @current_app = TrustedApp.where(:sha_hash => sha_hash).first

    # add authentication
  end
end
