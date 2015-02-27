require 'test_helper'

class SickSymptomsControllerTest < ActionController::TestCase
  setup do
    @sick_symptom = sick_symptoms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sick_symptoms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sick_symptom" do
    assert_difference('SickSymptom.count') do
      post :create, sick_symptom: { end_time: @sick_symptom.end_time, sick_id: @sick_symptom.sick_id, start_time: @sick_symptom.start_time, symptom_id: @sick_symptom.symptom_id }
    end

    assert_redirected_to sick_symptom_path(assigns(:sick_symptom))
  end

  test "should show sick_symptom" do
    get :show, id: @sick_symptom
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sick_symptom
    assert_response :success
  end

  test "should update sick_symptom" do
    patch :update, id: @sick_symptom, sick_symptom: { end_time: @sick_symptom.end_time, sick_id: @sick_symptom.sick_id, start_time: @sick_symptom.start_time, symptom_id: @sick_symptom.symptom_id }
    assert_redirected_to sick_symptom_path(assigns(:sick_symptom))
  end

  test "should destroy sick_symptom" do
    assert_difference('SickSymptom.count', -1) do
      delete :destroy, id: @sick_symptom
    end

    assert_redirected_to sick_symptoms_path
  end
end
