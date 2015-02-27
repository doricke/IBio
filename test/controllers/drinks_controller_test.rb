require 'test_helper'

class DrinksControllerTest < ActionController::TestCase
  setup do
    @drink = drinks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drinks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drink" do
    assert_difference('Drink.count') do
      post :create, drink: { amount: @drink.amount, consumed_at: @drink.consumed_at, food_id: @drink.food_id, individual_id: @drink.individual_id, unit_it: @drink.unit_it }
    end

    assert_redirected_to drink_path(assigns(:drink))
  end

  test "should show drink" do
    get :show, id: @drink
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drink
    assert_response :success
  end

  test "should update drink" do
    patch :update, id: @drink, drink: { amount: @drink.amount, consumed_at: @drink.consumed_at, food_id: @drink.food_id, individual_id: @drink.individual_id, unit_it: @drink.unit_it }
    assert_redirected_to drink_path(assigns(:drink))
  end

  test "should destroy drink" do
    assert_difference('Drink.count', -1) do
      delete :destroy, id: @drink
    end

    assert_redirected_to drinks_path
  end
end
