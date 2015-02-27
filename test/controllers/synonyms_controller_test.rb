require 'test_helper'

class SynonymsControllerTest < ActionController::TestCase
  setup do
    @synonym = synonyms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:synonyms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create synonym" do
    assert_difference('Synonym.count') do
      post :create, synonym: { itype_id: @synonym.itype_id, source_id: @synonym.source_id, synonym_name: @synonym.synonym_name, table_name: @synonym.table_name }
    end

    assert_redirected_to synonym_path(assigns(:synonym))
  end

  test "should show synonym" do
    get :show, id: @synonym
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @synonym
    assert_response :success
  end

  test "should update synonym" do
    patch :update, id: @synonym, synonym: { itype_id: @synonym.itype_id, source_id: @synonym.source_id, synonym_name: @synonym.synonym_name, table_name: @synonym.table_name }
    assert_redirected_to synonym_path(assigns(:synonym))
  end

  test "should destroy synonym" do
    assert_difference('Synonym.count', -1) do
      delete :destroy, id: @synonym
    end

    assert_redirected_to synonyms_path
  end
end
