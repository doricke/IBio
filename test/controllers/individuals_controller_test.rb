require 'test_helper'

class IndividualsControllerTest < ActionController::TestCase
  setup do
    @individual = individuals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:individuals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create individual" do
    assert_difference('Individual.count') do
      post :create, individual: { code_name: @individual.code_name, data_entry_id: @individual.data_entry_id, guid1: @individual.guid1, guid2: @individual.guid2, password_hash: @individual.password_hash, password_salt: @individual.password_salt, sex: @individual.sex }
    end

    assert_redirected_to individual_path(assigns(:individual))
  end

  test "should show individual" do
    get :show, id: @individual
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @individual
    assert_response :success
  end

  test "should update individual" do
    patch :update, id: @individual, individual: { code_name: @individual.code_name, data_entry_id: @individual.data_entry_id, guid1: @individual.guid1, guid2: @individual.guid2, password_hash: @individual.password_hash, password_salt: @individual.password_salt, sex: @individual.sex }
    assert_redirected_to individual_path(assigns(:individual))
  end

  test "should destroy individual" do
    assert_difference('Individual.count', -1) do
      delete :destroy, id: @individual
    end

    assert_redirected_to individuals_path
  end
end
