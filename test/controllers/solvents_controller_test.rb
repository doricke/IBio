require 'test_helper'

class SolventsControllerTest < ActionController::TestCase
  setup do
    @solvent = solvents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:solvents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create solvent" do
    assert_difference('Solvent.count') do
      post :create, solvent: { accessibility: @solvent.accessibility, biosequence_id: @solvent.biosequence_id, position: @solvent.position }
    end

    assert_redirected_to solvent_path(assigns(:solvent))
  end

  test "should show solvent" do
    get :show, id: @solvent
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @solvent
    assert_response :success
  end

  test "should update solvent" do
    patch :update, id: @solvent, solvent: { accessibility: @solvent.accessibility, biosequence_id: @solvent.biosequence_id, position: @solvent.position }
    assert_redirected_to solvent_path(assigns(:solvent))
  end

  test "should destroy solvent" do
    assert_difference('Solvent.count', -1) do
      delete :destroy, id: @solvent
    end

    assert_redirected_to solvents_path
  end
end
