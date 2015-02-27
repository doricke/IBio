require 'test_helper'

class AlignsControllerTest < ActionController::TestCase
  setup do
    @align = aligns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aligns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create align" do
    assert_difference('Align.count') do
      post :create, align: { align_rank: @align.align_rank, align_sequence: @align.align_sequence, biosequence_id: @align.biosequence_id, msa_id: @align.msa_id, updated_at: @align.updated_at }
    end

    assert_redirected_to align_path(assigns(:align))
  end

  test "should show align" do
    get :show, id: @align
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @align
    assert_response :success
  end

  test "should update align" do
    patch :update, id: @align, align: { align_rank: @align.align_rank, align_sequence: @align.align_sequence, biosequence_id: @align.biosequence_id, msa_id: @align.msa_id, updated_at: @align.updated_at }
    assert_redirected_to align_path(assigns(:align))
  end

  test "should destroy align" do
    assert_difference('Align.count', -1) do
      delete :destroy, id: @align
    end

    assert_redirected_to aligns_path
  end
end
