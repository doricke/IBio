class CreateStructureSequences < ActiveRecord::Migration
  def change
    create_table :structure_sequences do |t|
      t.integer :structure_id
      t.integer :biosequence_id
      t.string :chain, :limit => 4
    end  # do
  end  # change
    
  def self.up
    add_index :structure_sequences, [:biosequence_id], :name => :idx_structure_biosequences
  end  # up
end  # class
