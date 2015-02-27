require 'test_helper'

class ActivitySummariesControllerTest < ActionController::TestCase
  setup do
    @activity_summary = activity_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activity_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity_summary" do
    assert_difference('ActivitySummary.count') do
      post :create, activity_summary: { amount: @activity_summary.amount, end_type: @activity_summary.end_type, image_id: @activity_summary.image_id, individual_id: @activity_summary.individual_id, name: @activity_summary.name, qualifier: @activity_summary.qualifier, start_time: @activity_summary.start_time, type_id: @activity_summary.type_id }
    end

    assert_redirected_to activity_summary_path(assigns(:activity_summary))
  end

  test "should show activity_summary" do
    get :show, id: @activity_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity_summary
    assert_response :success
  end

  test "should update activity_summary" do
    patch :update, id: @activity_summary, activity_summary: { amount: @activity_summary.amount, end_type: @activity_summary.end_type, image_id: @activity_summary.image_id, individual_id: @activity_summary.individual_id, name: @activity_summary.name, qualifier: @activity_summary.qualifier, start_time: @activity_summary.start_time, type_id: @activity_summary.type_id }
    assert_redirected_to activity_summary_path(assigns(:activity_summary))
  end

  test "should destroy activity_summary" do
    assert_difference('ActivitySummary.count', -1) do
      delete :destroy, id: @activity_summary
    end

    assert_redirected_to activity_summaries_path
  end
end
