class CreateStructures < ActiveRecord::Migration
  def change
    create_table :structures do |t|
      t.string :name, :limit => 80
      t.integer :pdb_length
      t.text :pdb
    end  # do
  end  # change
    
  def self.up
    add_index :structures, [:name], :name => :idx_structures_name
  end  # up
end  # class
