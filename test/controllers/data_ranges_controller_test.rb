require 'test_helper'

class DataRangesControllerTest < ActionController::TestCase
  setup do
    @data_range = data_ranges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:data_ranges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create data_range" do
    assert_difference('DataRange.count') do
      post :create, data_range: { description: @data_range.description, itype_id: @data_range.itype_id, lower: @data_range.lower, qualifier: @data_range.qualifier, table_name: @data_range.table_name, upper: @data_range.upper }
    end

    assert_redirected_to data_range_path(assigns(:data_range))
  end

  test "should show data_range" do
    get :show, id: @data_range
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @data_range
    assert_response :success
  end

  test "should update data_range" do
    patch :update, id: @data_range, data_range: { description: @data_range.description, itype_id: @data_range.itype_id, lower: @data_range.lower, qualifier: @data_range.qualifier, table_name: @data_range.table_name, upper: @data_range.upper }
    assert_redirected_to data_range_path(assigns(:data_range))
  end

  test "should destroy data_range" do
    assert_difference('DataRange.count', -1) do
      delete :destroy, id: @data_range
    end

    assert_redirected_to data_ranges_path
  end
end
