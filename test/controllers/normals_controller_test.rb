require 'test_helper'

class NormalsControllerTest < ActionController::TestCase
  setup do
    @normal = normals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:normals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create normal" do
    assert_difference('Normal.count') do
      post :create, normal: { age_high: @normal.age_high, age_low: @normal.age_low, ethnic_id: @normal.ethnic_id, normal_high: @normal.normal_high, normal_low: @normal.normal_low, note_id: @normal.note_id, ref_range: @normal.ref_range, sex: @normal.sex }
    end

    assert_redirected_to normal_path(assigns(:normal))
  end

  test "should show normal" do
    get :show, id: @normal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @normal
    assert_response :success
  end

  test "should update normal" do
    patch :update, id: @normal, normal: { age_high: @normal.age_high, age_low: @normal.age_low, ethnic_id: @normal.ethnic_id, normal_high: @normal.normal_high, normal_low: @normal.normal_low, note_id: @normal.note_id, ref_range: @normal.ref_range, sex: @normal.sex }
    assert_redirected_to normal_path(assigns(:normal))
  end

  test "should destroy normal" do
    assert_difference('Normal.count', -1) do
      delete :destroy, id: @normal
    end

    assert_redirected_to normals_path
  end
end
