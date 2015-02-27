require 'test_helper'

class BiosequenceDomainsControllerTest < ActionController::TestCase
  setup do
    @biosequence_domain = biosequence_domains(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:biosequence_domains)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create biosequence_domain" do
    assert_difference('BiosequenceDomain.count') do
      post :create, biosequence_domain: { biosequence_id: @biosequence_domain.biosequence_id, domain_id: @biosequence_domain.domain_id, seq_end: @biosequence_domain.seq_end, seq_start: @biosequence_domain.seq_start }
    end

    assert_redirected_to biosequence_domain_path(assigns(:biosequence_domain))
  end

  test "should show biosequence_domain" do
    get :show, id: @biosequence_domain
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @biosequence_domain
    assert_response :success
  end

  test "should update biosequence_domain" do
    patch :update, id: @biosequence_domain, biosequence_domain: { biosequence_id: @biosequence_domain.biosequence_id, domain_id: @biosequence_domain.domain_id, seq_end: @biosequence_domain.seq_end, seq_start: @biosequence_domain.seq_start }
    assert_redirected_to biosequence_domain_path(assigns(:biosequence_domain))
  end

  test "should destroy biosequence_domain" do
    assert_difference('BiosequenceDomain.count', -1) do
      delete :destroy, id: @biosequence_domain
    end

    assert_redirected_to biosequence_domains_path
  end
end
