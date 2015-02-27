require 'test_helper'

class BiosequencesControllerTest < ActionController::TestCase
  setup do
    @biosequence = biosequences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:biosequences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create biosequence" do
    assert_difference('Biosequence.count') do
      post :create, biosequence: { aa_sequence: @biosequence.aa_sequence, copy_number: @biosequence.copy_number, exons: @biosequence.exons, gene_id: @biosequence.gene_id, mrna_sequence: @biosequence.mrna_sequence, name: @biosequence.name, organism_id: @biosequence.organism_id, source_id: @biosequence.source_id, updated_at: @biosequence.updated_at }
    end

    assert_redirected_to biosequence_path(assigns(:biosequence))
  end

  test "should show biosequence" do
    get :show, id: @biosequence
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @biosequence
    assert_response :success
  end

  test "should update biosequence" do
    patch :update, id: @biosequence, biosequence: { aa_sequence: @biosequence.aa_sequence, copy_number: @biosequence.copy_number, exons: @biosequence.exons, gene_id: @biosequence.gene_id, mrna_sequence: @biosequence.mrna_sequence, name: @biosequence.name, organism_id: @biosequence.organism_id, source_id: @biosequence.source_id, updated_at: @biosequence.updated_at }
    assert_redirected_to biosequence_path(assigns(:biosequence))
  end

  test "should destroy biosequence" do
    assert_difference('Biosequence.count', -1) do
      delete :destroy, id: @biosequence
    end

    assert_redirected_to biosequences_path
  end
end
