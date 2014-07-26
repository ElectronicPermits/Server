require 'test_helper'

class TrustedAppsControllerTest < ActionController::TestCase
  setup do
    @trusted_app = trusted_apps(:trusted_app_1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trusted_apps)
  end

  #test "should get new" do
    #get :new
    #assert_response :success
  #end

  #test "should create trusted_app" do
    #assert_difference('TrustedApp.count') do
      #post :create, trusted_app: { app_name: @trusted_app.app_name, description: @trusted_app.description, sha_hash: @trusted_app.sha_hash }
    #end

    #assert_redirected_to trusted_app_path(assigns(:trusted_app))
  #end

  #test "should show trusted_app" do
    #get :show, id: @trusted_app
    #assert_response :success
  #end

  #test "should get edit" do
    #get :edit, id: @trusted_app
    #assert_response :success
  #end

  #test "should update trusted_app" do
    #patch :update, id: @trusted_app, trusted_app: { app_name: @trusted_app.app_name, description: @trusted_app.description, sha_hash: @trusted_app.sha_hash }
    #assert_redirected_to trusted_app_path(assigns(:trusted_app))
  #end

  #test "should destroy trusted_app" do
    #assert_difference('TrustedApp.count', -1) do
      #delete :destroy, id: @trusted_app
    #end

    #assert_redirected_to trusted_apps_path
  #end
end
