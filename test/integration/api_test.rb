# This contains the tests for the API as it 
# is used by the trusted apps
#
# A lot of the functionality has already been 
# tested in the controllers for the api.
#
require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  setup do 
    https!
    # Create {,not} allowed app

    @app = TrustedApp.create(app_name: "APP", 
                             sha_hash: Digest::SHA1.hexdigest("APP"))
  end

  test "app can retrieve permit info" do # TODO change the id to beacon id
    # This should be done with a GET request to 
    # the necessary endpoint
    permit = Permit.first
    get permit_path permit.id, subdomain: :api, namespace: :v1, format: :json

    assert_equal permit[:id], json_response["id"]
  end

  test "app can retrieve company info" do
    company = Company.first
    get company_path company.id, subdomain: :api, namespace: :v1, format: :json

    assert_equal company.id, json_response["id"]
  end

  # Creation permissions
  test "app can't rate without perms" do
    host! "api.vcap.me"
    post "/v1/ratings", rating: { rating: 4 }, app_signature: @app.sha_hash
    assert_response(403)
  end

  test "app can't record service without perms" do
    # post '/services', subdomain: :api, namespace: :v1, format: :json, rating: { rating: 4 }, app_signature: @app.sha_hash
    host! "api.vcap.me"
    post '/v1/services', service: { start_latitude: 4, end_latitude:5, 
                                    start_longitude: 1, end_longitude: 1 }, 
                                    app_signature: @app.sha_hash
    assert_response(403)
  end

  def json_response
      JSON.parse @response.body
  end

end
