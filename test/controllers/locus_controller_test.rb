require 'test_helper'

class LocusControllerTest < ActionController::TestCase
  setup do
    @locu = locus(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create locu" do
    assert_difference('Locu.count') do
      post :create, locu: { chromosome: @locu.chromosome, flank3: @locu.flank3, flank5: @locu.flank5, name: @locu.name, position: @locu.position, type_id: @locu.type_id }
    end

    assert_redirected_to locu_path(assigns(:locu))
  end

  test "should show locu" do
    get :show, id: @locu
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @locu
    assert_response :success
  end

  test "should update locu" do
    patch :update, id: @locu, locu: { chromosome: @locu.chromosome, flank3: @locu.flank3, flank5: @locu.flank5, name: @locu.name, position: @locu.position, type_id: @locu.type_id }
    assert_redirected_to locu_path(assigns(:locu))
  end

  test "should destroy locu" do
    assert_difference('Locu.count', -1) do
      delete :destroy, id: @locu
    end

    assert_redirected_to locus_path
  end
end
