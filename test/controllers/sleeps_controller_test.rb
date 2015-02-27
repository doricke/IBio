require 'test_helper'

class SleepsControllerTest < ActionController::TestCase
  setup do
    @sleep = sleeps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sleeps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sleep" do
    assert_difference('Sleep.count') do
      post :create, sleep: { asleep: @sleep.asleep, end_time: @sleep.end_time, image_id: @sleep.image_id, individual_id: @sleep.individual_id, interruptions: @sleep.interruptions, qualifier: @sleep.qualifier, start_time: @sleep.start_time }
    end

    assert_redirected_to sleep_path(assigns(:sleep))
  end

  test "should show sleep" do
    get :show, id: @sleep
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sleep
    assert_response :success
  end

  test "should update sleep" do
    patch :update, id: @sleep, sleep: { asleep: @sleep.asleep, end_time: @sleep.end_time, image_id: @sleep.image_id, individual_id: @sleep.individual_id, interruptions: @sleep.interruptions, qualifier: @sleep.qualifier, start_time: @sleep.start_time }
    assert_redirected_to sleep_path(assigns(:sleep))
  end

  test "should destroy sleep" do
    assert_difference('Sleep.count', -1) do
      delete :destroy, id: @sleep
    end

    assert_redirected_to sleeps_path
  end
end
