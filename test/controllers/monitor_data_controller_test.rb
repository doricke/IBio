require 'test_helper'

class MonitorDataControllerTest < ActionController::TestCase
  setup do
    @monitor_datum = monitor_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:monitor_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create monitor_datum" do
    assert_difference('MonitorDatum.count') do
      post :create, monitor_datum: { attachment_id: @monitor_datum.attachment_id, data_vector: @monitor_datum.data_vector, end_time: @monitor_datum.end_time, image_id: @monitor_datum.image_id, individual_id: @monitor_datum.individual_id, instrument_id: @monitor_datum.instrument_id, itype_id: @monitor_datum.itype_id, points_per_hour: @monitor_datum.points_per_hour, points_per_second: @monitor_datum.points_per_second, start_time: @monitor_datum.start_time }
    end

    assert_redirected_to monitor_datum_path(assigns(:monitor_datum))
  end

  test "should show monitor_datum" do
    get :show, id: @monitor_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @monitor_datum
    assert_response :success
  end

  test "should update monitor_datum" do
    patch :update, id: @monitor_datum, monitor_datum: { attachment_id: @monitor_datum.attachment_id, data_vector: @monitor_datum.data_vector, end_time: @monitor_datum.end_time, image_id: @monitor_datum.image_id, individual_id: @monitor_datum.individual_id, instrument_id: @monitor_datum.instrument_id, itype_id: @monitor_datum.itype_id, points_per_hour: @monitor_datum.points_per_hour, points_per_second: @monitor_datum.points_per_second, start_time: @monitor_datum.start_time }
    assert_redirected_to monitor_datum_path(assigns(:monitor_datum))
  end

  test "should destroy monitor_datum" do
    assert_difference('MonitorDatum.count', -1) do
      delete :destroy, id: @monitor_datum
    end

    assert_redirected_to monitor_data_path
  end
end
