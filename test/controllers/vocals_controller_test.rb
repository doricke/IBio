require 'test_helper'

class VocalsControllerTest < ActionController::TestCase
  setup do
    @vocal = vocals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vocals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vocal" do
    assert_difference('Vocal.count') do
      post :create, vocal: { attachment_id: @vocal.attachment_id, individual_id: @vocal.individual_id, speech_text: @vocal.speech_text, start_time: @vocal.start_time }
    end

    assert_redirected_to vocal_path(assigns(:vocal))
  end

  test "should show vocal" do
    get :show, id: @vocal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vocal
    assert_response :success
  end

  test "should update vocal" do
    patch :update, id: @vocal, vocal: { attachment_id: @vocal.attachment_id, individual_id: @vocal.individual_id, speech_text: @vocal.speech_text, start_time: @vocal.start_time }
    assert_redirected_to vocal_path(assigns(:vocal))
  end

  test "should destroy vocal" do
    assert_difference('Vocal.count', -1) do
      delete :destroy, id: @vocal
    end

    assert_redirected_to vocals_path
  end
end
