require 'test_helper'

class DataSyncsControllerTest < ActionController::TestCase
  setup do
    @data_sync = data_syncs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:data_syncs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create data_sync" do
    assert_difference('DataSync.count') do
      post :create, data_sync: { algorithm_id: @data_sync.algorithm_id, individual_id: @data_sync.individual_id, instrument_id: @data_sync.instrument_id, updated_at: @data_sync.updated_at }
    end

    assert_redirected_to data_sync_path(assigns(:data_sync))
  end

  test "should show data_sync" do
    get :show, id: @data_sync
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @data_sync
    assert_response :success
  end

  test "should update data_sync" do
    patch :update, id: @data_sync, data_sync: { algorithm_id: @data_sync.algorithm_id, individual_id: @data_sync.individual_id, instrument_id: @data_sync.instrument_id, updated_at: @data_sync.updated_at }
    assert_redirected_to data_sync_path(assigns(:data_sync))
  end

  test "should destroy data_sync" do
    assert_difference('DataSync.count', -1) do
      delete :destroy, id: @data_sync
    end

    assert_redirected_to data_syncs_path
  end
end
