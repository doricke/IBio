require 'test_helper'

class MsasControllerTest < ActionController::TestCase
  setup do
    @msa = msas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:msas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create msa" do
    assert_difference('Msa.count') do
      post :create, msa: { category: @msa.category, description: @msa.description, gene_id: @msa.gene_id, msa_type: @msa.msa_type, name: @msa.name, updated_at: @msa.updated_at }
    end

    assert_redirected_to msa_path(assigns(:msa))
  end

  test "should show msa" do
    get :show, id: @msa
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @msa
    assert_response :success
  end

  test "should update msa" do
    patch :update, id: @msa, msa: { category: @msa.category, description: @msa.description, gene_id: @msa.gene_id, msa_type: @msa.msa_type, name: @msa.name, updated_at: @msa.updated_at }
    assert_redirected_to msa_path(assigns(:msa))
  end

  test "should destroy msa" do
    assert_difference('Msa.count', -1) do
      delete :destroy, id: @msa
    end

    assert_redirected_to msas_path
  end
end
