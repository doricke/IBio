class ModTables4 < ActiveRecord::Migration
  def change
    change_column :biosequences, :aa_sequence, :string, :limit => 4000
    change_column :diseases, :name, :string, :limit => 240
    
    add_index :variants, [:biosequence_id, :mutation, :sequence_start], :name => :idx_variants_triple
  end  # change
end  # class
