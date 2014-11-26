# This contains the tests for the API as it 
# is used by the trusted apps
#
require 'test_helper'

class TrustedAppsFlowsTest < ActionDispatch::IntegrationTest
  setup do #login
    https!

    @app = users(:user_1)
    log_in @app
  end

  test "app can retrieve permit info" do
    # TODO
  end

  test "app can retrieve company info" do
    # TODO
  end

  test "app can rate" do
    # TODO
  end

  test "app can't rate without perms" do
    # TODO
  end

  test "app can record service" do
    # TODO
  end

  test "app can't record service without perms" do
    # TODO
  end

end
