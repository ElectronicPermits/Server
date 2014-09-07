ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

# Convenience methods
def log_out
  visit '/manage/trusted_apps'
  if page.current_path == '/manage/trusted_apps' then
    click_link "sign_out" 
  end
end

def log_in user
  log_in_with_password user, 'password'
end

def log_in_with_password user, password
  log_out
  https!
  visit new_user_session_path
  within("#new_user") do
    fill_in "user_email",    with: user.email
    fill_in "user_password", with: password
  end
  click_button "Sign in" 

  assert page.current_path != new_user_session_path, 
    "Still on login page. Assuming login attempt unsuccessful."
end

def page_should_be path
  return page.current_path == path
end

def is_logged_in
  visit '/manage/users'
  return page_should_be '/manage/users'
end


