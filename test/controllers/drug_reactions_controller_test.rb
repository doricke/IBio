require 'test_helper'

class DrugReactionsControllerTest < ActionController::TestCase
  setup do
    @drug_reaction = drug_reactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drug_reactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drug_reaction" do
    assert_difference('DrugReaction.count') do
      post :create, drug_reaction: { drug_id: @drug_reaction.drug_id, pathway_id: @drug_reaction.pathway_id, reaction_id: @drug_reaction.reaction_id }
    end

    assert_redirected_to drug_reaction_path(assigns(:drug_reaction))
  end

  test "should show drug_reaction" do
    get :show, id: @drug_reaction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drug_reaction
    assert_response :success
  end

  test "should update drug_reaction" do
    patch :update, id: @drug_reaction, drug_reaction: { drug_id: @drug_reaction.drug_id, pathway_id: @drug_reaction.pathway_id, reaction_id: @drug_reaction.reaction_id }
    assert_redirected_to drug_reaction_path(assigns(:drug_reaction))
  end

  test "should destroy drug_reaction" do
    assert_difference('DrugReaction.count', -1) do
      delete :destroy, id: @drug_reaction
    end

    assert_redirected_to drug_reactions_path
  end
end
