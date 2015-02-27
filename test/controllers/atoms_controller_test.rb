require 'test_helper'

class AtomsControllerTest < ActionController::TestCase
  setup do
    @atom = atoms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:atoms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create atom" do
    assert_difference('Atom.count') do
      post :create, atom: { aa_name: @atom.aa_name, aa_residue: @atom.aa_residue, atom_end: @atom.atom_end, atom_start: @atom.atom_start, chain: @atom.chain, integer: @atom.integer, structure_id: @atom.structure_id }
    end

    assert_redirected_to atom_path(assigns(:atom))
  end

  test "should show atom" do
    get :show, id: @atom
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @atom
    assert_response :success
  end

  test "should update atom" do
    patch :update, id: @atom, atom: { aa_name: @atom.aa_name, aa_residue: @atom.aa_residue, atom_end: @atom.atom_end, atom_start: @atom.atom_start, chain: @atom.chain, integer: @atom.integer, structure_id: @atom.structure_id }
    assert_redirected_to atom_path(assigns(:atom))
  end

  test "should destroy atom" do
    assert_difference('Atom.count', -1) do
      delete :destroy, id: @atom
    end

    assert_redirected_to atoms_path
  end
end
