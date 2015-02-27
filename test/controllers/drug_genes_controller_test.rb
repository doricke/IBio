require 'test_helper'

class DrugGenesControllerTest < ActionController::TestCase
  setup do
    @drug_gene = drug_genes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drug_genes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drug_gene" do
    assert_difference('DrugGene.count') do
      post :create, drug_gene: { cpic_dosing: @drug_gene.cpic_dosing, drug_id: @drug_gene.drug_id, gene_id: @drug_gene.gene_id, pharm_gbk_id: @drug_gene.pharm_gbk_id }
    end

    assert_redirected_to drug_gene_path(assigns(:drug_gene))
  end

  test "should show drug_gene" do
    get :show, id: @drug_gene
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drug_gene
    assert_response :success
  end

  test "should update drug_gene" do
    patch :update, id: @drug_gene, drug_gene: { cpic_dosing: @drug_gene.cpic_dosing, drug_id: @drug_gene.drug_id, gene_id: @drug_gene.gene_id, pharm_gbk_id: @drug_gene.pharm_gbk_id }
    assert_redirected_to drug_gene_path(assigns(:drug_gene))
  end

  test "should destroy drug_gene" do
    assert_difference('DrugGene.count', -1) do
      delete :destroy, id: @drug_gene
    end

    assert_redirected_to drug_genes_path
  end
end
