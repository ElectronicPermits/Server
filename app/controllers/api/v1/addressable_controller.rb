# Base functionality for creating addresses
# permits
class API::V1::AddressableController < API::V1::BaseController

  protected
    def address_params
      result = {}
      if not params[:address].nil?
          result = params[:address].permit(:line1, :line2, :city, :state, :zipcode)
      end
      return result
    end

end
