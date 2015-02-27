require 'test_helper'

class MetaprofilesControllerTest < ActionController::TestCase
  setup do
    @metaprofile = metaprofiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:metaprofiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metaprofile" do
    assert_difference('Metaprofile.count') do
      post :create, metaprofile: { count: @metaprofile.count, guid1: @metaprofile.guid1, measured_at: @metaprofile.measured_at, organism_id: @metaprofile.organism_id }
    end

    assert_redirected_to metaprofile_path(assigns(:metaprofile))
  end

  test "should show metaprofile" do
    get :show, id: @metaprofile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @metaprofile
    assert_response :success
  end

  test "should update metaprofile" do
    patch :update, id: @metaprofile, metaprofile: { count: @metaprofile.count, guid1: @metaprofile.guid1, measured_at: @metaprofile.measured_at, organism_id: @metaprofile.organism_id }
    assert_redirected_to metaprofile_path(assigns(:metaprofile))
  end

  test "should destroy metaprofile" do
    assert_difference('Metaprofile.count', -1) do
      delete :destroy, id: @metaprofile
    end

    assert_redirected_to metaprofiles_path
  end
end
