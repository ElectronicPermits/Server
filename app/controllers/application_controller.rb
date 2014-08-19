class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #Handle https redirects
  force_ssl if: :ssl_required?

  def ssl_required?
    #ssl is forced for specific modules
    if Rails.env.development? then
      return false
    end

    class_name = self.class.to_s

    if not class_name.index("::").nil? then #it is a namespace
      module_name = self.class.to_s.split("::").first.downcase
      return module_name == "manage" || module_name == "api" 
    else
      return false
    end

  end

  def namespace_name
    controller.class.name.split("::").first
  end
end
