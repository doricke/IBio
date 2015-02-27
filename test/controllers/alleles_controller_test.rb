require 'test_helper'

class AllelesControllerTest < ActionController::TestCase
  setup do
    @allele = alleles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:alleles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create allele" do
    assert_difference('Allele.count') do
      post :create, allele: { allele_frequency: @allele.allele_frequency, ethnic_id: @allele.ethnic_id, locus_id: @allele.locus_id, name: @allele.name, regular_expression: @allele.regular_expression, seq: @allele.seq }
    end

    assert_redirected_to allele_path(assigns(:allele))
  end

  test "should show allele" do
    get :show, id: @allele
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @allele
    assert_response :success
  end

  test "should update allele" do
    patch :update, id: @allele, allele: { allele_frequency: @allele.allele_frequency, ethnic_id: @allele.ethnic_id, locus_id: @allele.locus_id, name: @allele.name, regular_expression: @allele.regular_expression, seq: @allele.seq }
    assert_redirected_to allele_path(assigns(:allele))
  end

  test "should destroy allele" do
    assert_difference('Allele.count', -1) do
      delete :destroy, id: @allele
    end

    assert_redirected_to alleles_path
  end
end
