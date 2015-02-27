require 'test_helper'

class VariantsControllerTest < ActionController::TestCase
  setup do
    @variant = variants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create variant" do
    assert_difference('Variant.count') do
      post :create, variant: { biosequence_id: @variant.biosequence_id, disease_id: @variant.disease_id, guid2: @variant.guid2, mutation: @variant.mutation, mutation_type: @variant.mutation_type, sequence_end: @variant.sequence_end, sequence_start: @variant.sequence_start, sequence_type: @variant.sequence_type }
    end

    assert_redirected_to variant_path(assigns(:variant))
  end

  test "should show variant" do
    get :show, id: @variant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @variant
    assert_response :success
  end

  test "should update variant" do
    patch :update, id: @variant, variant: { biosequence_id: @variant.biosequence_id, disease_id: @variant.disease_id, guid2: @variant.guid2, mutation: @variant.mutation, mutation_type: @variant.mutation_type, sequence_end: @variant.sequence_end, sequence_start: @variant.sequence_start, sequence_type: @variant.sequence_type }
    assert_redirected_to variant_path(assigns(:variant))
  end

  test "should destroy variant" do
    assert_difference('Variant.count', -1) do
      delete :destroy, id: @variant
    end

    assert_redirected_to variants_path
  end
end
