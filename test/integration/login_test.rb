require 'test_helper'

# Testing for accessibility of endpoints, etc
class LoginTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_1)
  end

  test "should redirect to https" do
    get '/users/sign_in'
    assert response.code == "301", "didn't redirect login to https"
  end

  test "log in with capybara" do
    log_in @user
  end

  test "login and view trusted apps" do
    log_in @user

    visit manage_trusted_apps_path
    page_should_be manage_trusted_apps_path
  end

  test "can't log in bad credentials" do
    log_out
    visit new_user_session_path
    within("#new_user") do
      fill_in "Email", with: @user.email
      fill_in "Password", with: "asdfdkeenenclss"
    end

    click_button 'Sign in'
    assert page.current_path == new_user_session_path,
      "Should remain on login screen if credentials are invalid"
  end

  test "sign up is not open" do
    log_out
    visit new_manage_user_path
    assert_not page_should_be(new_manage_user_path),
      "User creation is publicly accessible"
  end
end
