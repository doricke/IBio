require 'test_helper'

class RelatedsControllerTest < ActionController::TestCase
  setup do
    @related = relateds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:relateds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create related" do
    assert_difference('Related.count') do
      post :create, related: { family_id: @related.family_id, guid1a: @related.guid1a, guild1b: @related.guild1b, relation: @related.relation, type_id: @related.type_id }
    end

    assert_redirected_to related_path(assigns(:related))
  end

  test "should show related" do
    get :show, id: @related
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @related
    assert_response :success
  end

  test "should update related" do
    patch :update, id: @related, related: { family_id: @related.family_id, guid1a: @related.guid1a, guild1b: @related.guild1b, relation: @related.relation, type_id: @related.type_id }
    assert_redirected_to related_path(assigns(:related))
  end

  test "should destroy related" do
    assert_difference('Related.count', -1) do
      delete :destroy, id: @related
    end

    assert_redirected_to relateds_path
  end
end
