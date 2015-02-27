class ModTables13 < ActiveRecord::Migration
  def change
      add_column :variants, :dp4, :string, :limit => 20
      add_column :variants, :ref, :string, :limit => 20
      add_column :variants, :alt, :string, :limit => 20
      
      add_index :variants, [:biosequence_id, :instrument_id, :guid2, :sequence_start], :name => :idx_variants_find
  end
end
