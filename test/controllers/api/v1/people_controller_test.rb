require 'test_helper'

class API::V1::PeopleControllerTest < ActionController::TestCase
  setup do
    request.env['HTTPS'] = 'on'
    @person = people(:person_1)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:people)
  end

  #test "should get new" do
    #get :new
    #assert_response :success
  #end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, :format => :json, person: { date_of_birth: @person.date_of_birth, first_name: @person.first_name, height: @person.height, last_name: @person.last_name, middle_name: @person.middle_name, phone_number: @person.phone_number, race: @person.race, sex: @person.sex, weight: @person.weight }, app_signature: @person.trusted_app.sha_hash
    end

  end

  test "should show person" do
    get :show, :format => :json, id: @person
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, id: @person
    #assert_response :success
  #end

  test "should update person" do
    patch :update, :format => :json, id: @person, person: { date_of_birth: @person.date_of_birth, first_name: @person.first_name, height: @person.height, last_name: @person.last_name, middle_name: @person.middle_name, phone_number: @person.phone_number, race: @person.race, sex: @person.sex, weight: @person.weight }, app_signature: @person.trusted_app.sha_hash
  end

  #test "should destroy person" do
    #assert_difference('API::V1::Person.count', -1) do
      #delete :destroy, id: @person
    #end

  #end
end
