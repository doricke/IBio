require 'test_helper'

class MeasurementsControllerTest < ActionController::TestCase
  setup do
    @measurement = measurements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:measurements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create measurement" do
    assert_difference('Measurement.count') do
      post :create, measurement: { created_at: @measurement.created_at, individual_id: @measurement.individual_id, name: @measurement.name, normal_id: @measurement.normal_id, note_id: @measurement.note_id, result: @measurement.result, type_id: @measurement.type_id, unit_id: @measurement.unit_id }
    end

    assert_redirected_to measurement_path(assigns(:measurement))
  end

  test "should show measurement" do
    get :show, id: @measurement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @measurement
    assert_response :success
  end

  test "should update measurement" do
    patch :update, id: @measurement, measurement: { created_at: @measurement.created_at, individual_id: @measurement.individual_id, name: @measurement.name, normal_id: @measurement.normal_id, note_id: @measurement.note_id, result: @measurement.result, type_id: @measurement.type_id, unit_id: @measurement.unit_id }
    assert_redirected_to measurement_path(assigns(:measurement))
  end

  test "should destroy measurement" do
    assert_difference('Measurement.count', -1) do
      delete :destroy, id: @measurement
    end

    assert_redirected_to measurements_path
  end
end
