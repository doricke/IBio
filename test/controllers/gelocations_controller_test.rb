require 'test_helper'

class GelocationsControllerTest < ActionController::TestCase
  setup do
    @gelocation = gelocations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gelocations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gelocation" do
    assert_difference('Gelocation.count') do
      post :create, gelocation: { individual_id: @gelocation.individual_id, latitude: @gelocation.latitude, logitude: @gelocation.logitude, timepoint: @gelocation.timepoint }
    end

    assert_redirected_to gelocation_path(assigns(:gelocation))
  end

  test "should show gelocation" do
    get :show, id: @gelocation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gelocation
    assert_response :success
  end

  test "should update gelocation" do
    patch :update, id: @gelocation, gelocation: { individual_id: @gelocation.individual_id, latitude: @gelocation.latitude, logitude: @gelocation.logitude, timepoint: @gelocation.timepoint }
    assert_redirected_to gelocation_path(assigns(:gelocation))
  end

  test "should destroy gelocation" do
    assert_difference('Gelocation.count', -1) do
      delete :destroy, id: @gelocation
    end

    assert_redirected_to gelocations_path
  end
end
