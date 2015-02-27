require 'test_helper'

class PanelsControllerTest < ActionController::TestCase
  setup do
    @panel = panels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:panels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create panel" do
    assert_difference('Panel.count') do
      post :create, panel: { attachment_id: @panel.attachment_id, end_time: @panel.end_time, individual_id: @panel.individual_id, start_time: @panel.start_time, type_id: @panel.type_id }
    end

    assert_redirected_to panel_path(assigns(:panel))
  end

  test "should show panel" do
    get :show, id: @panel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @panel
    assert_response :success
  end

  test "should update panel" do
    patch :update, id: @panel, panel: { attachment_id: @panel.attachment_id, end_time: @panel.end_time, individual_id: @panel.individual_id, start_time: @panel.start_time, type_id: @panel.type_id }
    assert_redirected_to panel_path(assigns(:panel))
  end

  test "should destroy panel" do
    assert_difference('Panel.count', -1) do
      delete :destroy, id: @panel
    end

    assert_redirected_to panels_path
  end
end
