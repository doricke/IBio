require 'test_helper'

class DiseaseGenesControllerTest < ActionController::TestCase
  setup do
    @disease_gene = disease_genes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:disease_genes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create disease_gene" do
    assert_difference('DiseaseGene.count') do
      post :create, disease_gene: { disease_id: @disease_gene.disease_id, gene_id: @disease_gene.gene_id }
    end

    assert_redirected_to disease_gene_path(assigns(:disease_gene))
  end

  test "should show disease_gene" do
    get :show, id: @disease_gene
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @disease_gene
    assert_response :success
  end

  test "should update disease_gene" do
    patch :update, id: @disease_gene, disease_gene: { disease_id: @disease_gene.disease_id, gene_id: @disease_gene.gene_id }
    assert_redirected_to disease_gene_path(assigns(:disease_gene))
  end

  test "should destroy disease_gene" do
    assert_difference('DiseaseGene.count', -1) do
      delete :destroy, id: @disease_gene
    end

    assert_redirected_to disease_genes_path
  end
end
