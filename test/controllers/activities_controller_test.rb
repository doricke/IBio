require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  setup do
    @activity = activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity" do
    assert_difference('Activity.count') do
      post :create, activity: { activity_name: @activity.activity_name, attachment_id: @activity.attachment_id, end_time: @activity.end_time, image_id: @activity.image_id, individual_id: @activity.individual_id, intensity: @activity.intensity, note_id: @activity.note_id, qualifier: @activity.qualifier, start_time: @activity.start_time, type_id: @activity.type_id }
    end

    assert_redirected_to activity_path(assigns(:activity))
  end

  test "should show activity" do
    get :show, id: @activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity
    assert_response :success
  end

  test "should update activity" do
    patch :update, id: @activity, activity: { activity_name: @activity.activity_name, attachment_id: @activity.attachment_id, end_time: @activity.end_time, image_id: @activity.image_id, individual_id: @activity.individual_id, intensity: @activity.intensity, note_id: @activity.note_id, qualifier: @activity.qualifier, start_time: @activity.start_time, type_id: @activity.type_id }
    assert_redirected_to activity_path(assigns(:activity))
  end

  test "should destroy activity" do
    assert_difference('Activity.count', -1) do
      delete :destroy, id: @activity
    end

    assert_redirected_to activities_path
  end
end
