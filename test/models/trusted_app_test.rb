require 'test_helper'

class TrustedAppTest < ActiveSupport::TestCase

  test "should not save with duplicate hash" do
    app = TrustedApp.new
    appCopy = trusted_apps(:trusted_app_1)
    app.app_name = "test"
    app.sha_hash = appCopy.sha_hash
    assert_not app.save
  end

  test "should not save without app_name" do
    app = trusted_apps(:trusted_app_1)
    app.app_name = nil
    assert_not app.save
  end

end
