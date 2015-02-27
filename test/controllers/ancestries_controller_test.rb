require 'test_helper'

class AncestriesControllerTest < ActionController::TestCase
  setup do
    @ancestry = ancestries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ancestries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ancestry" do
    assert_difference('Ancestry.count') do
      post :create, ancestry: { ethnic_id: @ancestry.ethnic_id, individual_id: @ancestry.individual_id, percent: @ancestry.percent }
    end

    assert_redirected_to ancestry_path(assigns(:ancestry))
  end

  test "should show ancestry" do
    get :show, id: @ancestry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ancestry
    assert_response :success
  end

  test "should update ancestry" do
    patch :update, id: @ancestry, ancestry: { ethnic_id: @ancestry.ethnic_id, individual_id: @ancestry.individual_id, percent: @ancestry.percent }
    assert_redirected_to ancestry_path(assigns(:ancestry))
  end

  test "should destroy ancestry" do
    assert_difference('Ancestry.count', -1) do
      delete :destroy, id: @ancestry
    end

    assert_redirected_to ancestries_path
  end
end
