class CreateAtoms < ActiveRecord::Migration
  def change
    create_table :atoms do |t|
      t.integer :structure_id
      t.string  :chain, :limit => 4
      t.integer :aa_residue
      t.string  :aa_name, :limit => 8
      t.integer :atom_start
      t.integer :atom_end
    end  # do
  end  # change
  
  def self.up
    add_index :atoms, [:structure_id], :name => :idx_atoms_structure
    add_index :atoms, [:structure_id, :chain], :name => :idx_atoms_structure_chain
  end  # up
end  # class
