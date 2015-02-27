require 'test_helper'

class GeneReactionsControllerTest < ActionController::TestCase
  setup do
    @gene_reaction = gene_reactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gene_reactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gene_reaction" do
    assert_difference('GeneReaction.count') do
      post :create, gene_reaction: { gene_id: @gene_reaction.gene_id, pathway_id: @gene_reaction.pathway_id, reaction_id: @gene_reaction.reaction_id, role_itype_id: @gene_reaction.role_itype_id }
    end

    assert_redirected_to gene_reaction_path(assigns(:gene_reaction))
  end

  test "should show gene_reaction" do
    get :show, id: @gene_reaction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gene_reaction
    assert_response :success
  end

  test "should update gene_reaction" do
    patch :update, id: @gene_reaction, gene_reaction: { gene_id: @gene_reaction.gene_id, pathway_id: @gene_reaction.pathway_id, reaction_id: @gene_reaction.reaction_id, role_itype_id: @gene_reaction.role_itype_id }
    assert_redirected_to gene_reaction_path(assigns(:gene_reaction))
  end

  test "should destroy gene_reaction" do
    assert_difference('GeneReaction.count', -1) do
      delete :destroy, id: @gene_reaction
    end

    assert_redirected_to gene_reactions_path
  end
end
