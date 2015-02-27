require 'test_helper'

class SicksControllerTest < ActionController::TestCase
  setup do
    @sick = sicks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sicks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sick" do
    assert_difference('Sick.count') do
      post :create, sick: { end_time: @sick.end_time, guid1: @sick.guid1, start_time: @sick.start_time, type_id: @sick.type_id }
    end

    assert_redirected_to sick_path(assigns(:sick))
  end

  test "should show sick" do
    get :show, id: @sick
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sick
    assert_response :success
  end

  test "should update sick" do
    patch :update, id: @sick, sick: { end_time: @sick.end_time, guid1: @sick.guid1, start_time: @sick.start_time, type_id: @sick.type_id }
    assert_redirected_to sick_path(assigns(:sick))
  end

  test "should destroy sick" do
    assert_difference('Sick.count', -1) do
      delete :destroy, id: @sick
    end

    assert_redirected_to sicks_path
  end
end
