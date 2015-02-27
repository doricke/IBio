require 'test_helper'

class AttachmentsControllerTest < ActionController::TestCase
  setup do
    @attachment = attachments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attachments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attachment" do
    assert_difference('Attachment.count') do
      post :create, attachment: { content_type: @attachment.content_type, created_at: @attachment.created_at, file_binary: @attachment.file_binary, file_path: @attachment.file_path, file_text: @attachment.file_text, individual_id: @attachment.individual_id, name: @attachment.name, type_id: @attachment.type_id }
    end

    assert_redirected_to attachment_path(assigns(:attachment))
  end

  test "should show attachment" do
    get :show, id: @attachment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @attachment
    assert_response :success
  end

  test "should update attachment" do
    patch :update, id: @attachment, attachment: { content_type: @attachment.content_type, created_at: @attachment.created_at, file_binary: @attachment.file_binary, file_path: @attachment.file_path, file_text: @attachment.file_text, individual_id: @attachment.individual_id, name: @attachment.name, type_id: @attachment.type_id }
    assert_redirected_to attachment_path(assigns(:attachment))
  end

  test "should destroy attachment" do
    assert_difference('Attachment.count', -1) do
      delete :destroy, id: @attachment
    end

    assert_redirected_to attachments_path
  end
end
