require 'test_helper'

class GosControllerTest < ActionController::TestCase
  setup do
    @go = gos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create go" do
    assert_difference('Go.count') do
      post :create, go: { gene_id: @go.gene_id, itype_id: @go.itype_id, pubmed: @go.pubmed, term: @go.term }
    end

    assert_redirected_to go_path(assigns(:go))
  end

  test "should show go" do
    get :show, id: @go
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @go
    assert_response :success
  end

  test "should update go" do
    patch :update, id: @go, go: { gene_id: @go.gene_id, itype_id: @go.itype_id, pubmed: @go.pubmed, term: @go.term }
    assert_redirected_to go_path(assigns(:go))
  end

  test "should destroy go" do
    assert_difference('Go.count', -1) do
      delete :destroy, id: @go
    end

    assert_redirected_to gos_path
  end
end
