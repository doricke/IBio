require 'test_helper'

class AlleleCallsControllerTest < ActionController::TestCase
  setup do
    @allele_call = allele_calls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:allele_calls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create allele_call" do
    assert_difference('AlleleCall.count') do
      post :create, allele_call: { allele_call: @allele_call.allele_call, allele_count: @allele_call.allele_count, allele_name: @allele_call.allele_name, created_at: @allele_call.created_at, experiment_id: @allele_call.experiment_id, guid2: @allele_call.guid2, locus_id: @allele_call.locus_id }
    end

    assert_redirected_to allele_call_path(assigns(:allele_call))
  end

  test "should show allele_call" do
    get :show, id: @allele_call
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @allele_call
    assert_response :success
  end

  test "should update allele_call" do
    patch :update, id: @allele_call, allele_call: { allele_call: @allele_call.allele_call, allele_count: @allele_call.allele_count, allele_name: @allele_call.allele_name, created_at: @allele_call.created_at, experiment_id: @allele_call.experiment_id, guid2: @allele_call.guid2, locus_id: @allele_call.locus_id }
    assert_redirected_to allele_call_path(assigns(:allele_call))
  end

  test "should destroy allele_call" do
    assert_difference('AlleleCall.count', -1) do
      delete :destroy, id: @allele_call
    end

    assert_redirected_to allele_calls_path
  end
end
