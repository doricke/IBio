class ModTables2 < ActiveRecord::Migration
  def change
    add_column :genes, :organism_id, :integer
    add_column :effects, :guid2, :string, :limit => 32
    add_column :effects, :residue, :integer
    change_column :variants, :mutation, :string, :limit => 80
  end  # change
end  # class
