require 'test_helper'

class TrustedAppsFlowsTest < ActionDispatch::IntegrationTest
  setup do #login
    https!

    @user = users(:user_1)
    puts "email: #{@user.email} password: #{@user.password}"
      visit new_user_session_path
      fill_in "Email",    with: @user.email
      fill_in "Password", with: 'password'
      click_button "Sign in" 

  end

  test "should view trusted apps index" do
    assert false
    #TODO
  end

  test "should show trusted app" do
    #TODO
  end

  test "should delete trusted app" do
    #TODO
  end

  test "should edit trusted app" do
    #TODO
  end

end
