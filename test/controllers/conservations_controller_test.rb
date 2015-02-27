require 'test_helper'

class ConservationsControllerTest < ActionController::TestCase
  setup do
    @conservation = conservations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conservations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conservation" do
    assert_difference('Conservation.count') do
      post :create, conservation: { biosequence_id: @conservation.biosequence_id, level: @conservation.level, position: @conservation.position }
    end

    assert_redirected_to conservation_path(assigns(:conservation))
  end

  test "should show conservation" do
    get :show, id: @conservation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conservation
    assert_response :success
  end

  test "should update conservation" do
    patch :update, id: @conservation, conservation: { biosequence_id: @conservation.biosequence_id, level: @conservation.level, position: @conservation.position }
    assert_redirected_to conservation_path(assigns(:conservation))
  end

  test "should destroy conservation" do
    assert_difference('Conservation.count', -1) do
      delete :destroy, id: @conservation
    end

    assert_redirected_to conservations_path
  end
end
