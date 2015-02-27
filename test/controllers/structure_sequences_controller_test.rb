require 'test_helper'

class StructureSequencesControllerTest < ActionController::TestCase
  setup do
    @structure_sequence = structure_sequences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:structure_sequences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create structure_sequence" do
    assert_difference('StructureSequence.count') do
      post :create, structure_sequence: { biosequence_id: @structure_sequence.biosequence_id, chain: @structure_sequence.chain, structure_id: @structure_sequence.structure_id }
    end

    assert_redirected_to structure_sequence_path(assigns(:structure_sequence))
  end

  test "should show structure_sequence" do
    get :show, id: @structure_sequence
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @structure_sequence
    assert_response :success
  end

  test "should update structure_sequence" do
    patch :update, id: @structure_sequence, structure_sequence: { biosequence_id: @structure_sequence.biosequence_id, chain: @structure_sequence.chain, structure_id: @structure_sequence.structure_id }
    assert_redirected_to structure_sequence_path(assigns(:structure_sequence))
  end

  test "should destroy structure_sequence" do
    assert_difference('StructureSequence.count', -1) do
      delete :destroy, id: @structure_sequence
    end

    assert_redirected_to structure_sequences_path
  end
end
