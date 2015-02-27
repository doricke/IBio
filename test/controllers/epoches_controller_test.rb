require 'test_helper'

class EpochesControllerTest < ActionController::TestCase
  setup do
    @epoch = epoches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:epoches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create epoch" do
    assert_difference('Epoch.count') do
      post :create, epoch: { day: @epoch.day, hour: @epoch.hour, minute: @epoch.minute, month: @epoch.month, second: @epoch.second, usec: @epoch.usec, year: @epoch.year }
    end

    assert_redirected_to epoch_path(assigns(:epoch))
  end

  test "should show epoch" do
    get :show, id: @epoch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @epoch
    assert_response :success
  end

  test "should update epoch" do
    patch :update, id: @epoch, epoch: { day: @epoch.day, hour: @epoch.hour, minute: @epoch.minute, month: @epoch.month, second: @epoch.second, usec: @epoch.usec, year: @epoch.year }
    assert_redirected_to epoch_path(assigns(:epoch))
  end

  test "should destroy epoch" do
    assert_difference('Epoch.count', -1) do
      delete :destroy, id: @epoch
    end

    assert_redirected_to epoches_path
  end
end
