class ModTables < ActiveRecord::Migration
  def change
    add_column :organisms, :genus, :string, :limit => 200
    add_column :organisms, :species, :string, :limit => 200
    change_column :genes, :name, :string, :limit => 200
  end  # change
end  # class
