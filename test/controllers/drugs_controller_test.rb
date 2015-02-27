require 'test_helper'

class DrugsControllerTest < ActionController::TestCase
  setup do
    @drug = drugs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drugs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drug" do
    assert_difference('Drug.count') do
      post :create, drug: { name: @drug.name, note_id: @drug.note_id }
    end

    assert_redirected_to drug_path(assigns(:drug))
  end

  test "should show drug" do
    get :show, id: @drug
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drug
    assert_response :success
  end

  test "should update drug" do
    patch :update, id: @drug, drug: { name: @drug.name, note_id: @drug.note_id }
    assert_redirected_to drug_path(assigns(:drug))
  end

  test "should destroy drug" do
    assert_difference('Drug.count', -1) do
      delete :destroy, id: @drug
    end

    assert_redirected_to drugs_path
  end
end
