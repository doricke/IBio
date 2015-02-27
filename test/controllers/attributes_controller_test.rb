require 'test_helper'

class AttributesControllerTest < ActionController::TestCase
  setup do
    @attribute = attributes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attributes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attribute" do
    assert_difference('Attribute.count') do
      post :create, attribute: { amount: @attribute.amount, category: @attribute.category, individual_id: @attribute.individual_id, measured_at: @attribute.measured_at, name: @attribute.name, unit_id: @attribute.unit_id }
    end

    assert_redirected_to attribute_path(assigns(:attribute))
  end

  test "should show attribute" do
    get :show, id: @attribute
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @attribute
    assert_response :success
  end

  test "should update attribute" do
    patch :update, id: @attribute, attribute: { amount: @attribute.amount, category: @attribute.category, individual_id: @attribute.individual_id, measured_at: @attribute.measured_at, name: @attribute.name, unit_id: @attribute.unit_id }
    assert_redirected_to attribute_path(assigns(:attribute))
  end

  test "should destroy attribute" do
    assert_difference('Attribute.count', -1) do
      delete :destroy, id: @attribute
    end

    assert_redirected_to attributes_path
  end
end
