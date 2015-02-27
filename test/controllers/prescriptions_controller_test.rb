require 'test_helper'

class PrescriptionsControllerTest < ActionController::TestCase
  setup do
    @prescription = prescriptions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prescriptions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prescription" do
    assert_difference('Prescription.count') do
      post :create, prescription: { daily: @prescription.daily, dose: @prescription.dose, drug_id: @prescription.drug_id, end_time: @prescription.end_time, guid1: @prescription.guid1, start_time: @prescription.start_time, unit_it: @prescription.unit_it }
    end

    assert_redirected_to prescription_path(assigns(:prescription))
  end

  test "should show prescription" do
    get :show, id: @prescription
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prescription
    assert_response :success
  end

  test "should update prescription" do
    patch :update, id: @prescription, prescription: { daily: @prescription.daily, dose: @prescription.dose, drug_id: @prescription.drug_id, end_time: @prescription.end_time, guid1: @prescription.guid1, start_time: @prescription.start_time, unit_it: @prescription.unit_it }
    assert_redirected_to prescription_path(assigns(:prescription))
  end

  test "should destroy prescription" do
    assert_difference('Prescription.count', -1) do
      delete :destroy, id: @prescription
    end

    assert_redirected_to prescriptions_path
  end
end
