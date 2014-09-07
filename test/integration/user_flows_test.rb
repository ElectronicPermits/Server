require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  setup do #login
    https!

    @user = users(:user_1)

    #Log out if necessary
    log_out
    log_in @user
  end

  test "view users index" do
    visit '/manage/users'
    assert page.status_code == 200
  end

  test "can create users" do

    visit new_manage_user_path
    assert page.current_path == new_manage_user_path, 
      "redirected to #{page.current_path} (should be #{new_manage_user_path})"

    assert_difference('User.count', 1) do

      within("#new_user") do
        fill_in "Email", with: "NEW_USER@EMAIL.com"
        fill_in "Password", with: "asdfdkeenenclss"
        fill_in "Password confirmation", with: "asdfdkeenenclss"
      end

      click_button 'Submit'
    end

    #Make sure you are not logged in as new user
  end

  test 'can delete user' do

    log_out
    @user2 = users(:user_2)

    log_in @user2

    assert_difference('User.count', -1) do
      visit manage_users_path
      click_link("delete_user_#{@user2.id.to_s}")
    end

    assert_not is_logged_in, "Logged in though user profile is deleted"

  end

  test "can change user email" do
    @user3 = users(:user_3)
    new_email = "NEW_EMAIL@DFS.com"

    visit edit_manage_user_path(@user3)
    fill_in "Email",    with: new_email
    click_button "Submit"

    assert page.current_path == manage_user_path(@user3),
      "Didn't redirect to show user page. Suspecting error in editing"

    assert page.has_text?(new_email.downcase), 
      "Didn't find new email on show user page"
  end

  test "can change user password" do
    @user4 = users(:user_4)
    new_password = "ASDASDASDASD"
    
    visit edit_manage_user_path(@user4)
    fill_in "Password",    with: new_password
    fill_in "Password confirmation",    with: new_password
    click_button "Submit"

    assert page_should_be(manage_user_path(@user4)), 
      "Password change unsuccessful"
    
    #Try to log in with new user
    log_in_with_password @user4, new_password
  end

  test "should be able to log out" do
    log_out
    visit manage_users_path
    assert page_should_be(new_user_session_path),
      "Didn't log out successfully"
  end

end
