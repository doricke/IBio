require 'test_helper'

class EthnicsControllerTest < ActionController::TestCase
  setup do
    @ethnic = ethnics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ethnics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ethnic" do
    assert_difference('Ethnic.count') do
      post :create, ethnic: { name: @ethnic.name, race: @ethnic.race }
    end

    assert_redirected_to ethnic_path(assigns(:ethnic))
  end

  test "should show ethnic" do
    get :show, id: @ethnic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ethnic
    assert_response :success
  end

  test "should update ethnic" do
    patch :update, id: @ethnic, ethnic: { name: @ethnic.name, race: @ethnic.race }
    assert_redirected_to ethnic_path(assigns(:ethnic))
  end

  test "should destroy ethnic" do
    assert_difference('Ethnic.count', -1) do
      delete :destroy, id: @ethnic
    end

    assert_redirected_to ethnics_path
  end
end
