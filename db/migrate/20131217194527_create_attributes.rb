class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.integer :individual_id
      t.integer :unit_id
      t.string :name, :limit => 32
      t.string :category, :limit => 32
      t.float :amount
      t.datetime :measured_at
    end  # do
  end  # change
    
  def self.up
    add_index :attributes, [:individual_id], :name => :idx_attributes_individual
  end  # up
end  # class
