# This contains the tests for editing 
# trusted apps from web interface
#
require 'test_helper'

class TrustedAppsFlowsTest < ActionDispatch::IntegrationTest
  setup do #login
    https!

    @user = users(:user_1)
    log_in @user
  end

  test "view trusted_app index" do
    visit manage_trusted_apps_path
    assert page_should_be(manage_trusted_apps_path)
  end

  test "should show trusted app" do
    trusted_app = trusted_apps(:trusted_app_1)

    visit manage_trusted_apps_path
    click_link "show_#{trusted_app.id}"
    assert page_should_be(manage_trusted_app_path(trusted_app)),
      "Not showing correct app"
  end

  test "should edit trusted app" do
    visit manage_trusted_apps_path
    click_link "edit_#{trusted_app.id}"
    assert page_should_be(edit_manage_trusted_app_path(trusted_app)),
      "Not editing app..."

    new_description = "A FANTASTIC app!"

    fill_in "description", new_description
    click_button "Submit"

    assert page_should_be(manage_trusted_app_path(trusted_app))
    assert page.has_text?(new_description), 
      "Page does not show updated description"
  end

  test "should delete trusted app" do
    visit manage_trusted_apps_path

    assert_difference('TrustedApp.count', 1) do
      click_link "delete_#{trusted_app.id}"
    end
  end

  test "should add permissions to trusted app" do
    #TODO
  end

  test "should remove permissions from trusted app" do
    #TODO
  end

end
