# This contains general public browsing tests
require 'test_helper'

# Testing public user browsing the site
class PublicBrowsing < ActionDispatch::IntegrationTest
  # I will check the root, and the following for each
  # show, index, etc

  test "home should be service type index" do
    visit ''
    assert page.current_path == service_types_path,
      "Root directory is not service types index"
  end

  # I will plan on testing the following:
  # clicking on the show link of the service 
  # types, etc

end
