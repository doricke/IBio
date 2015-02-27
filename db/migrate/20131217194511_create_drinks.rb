class CreateDrinks < ActiveRecord::Migration
  def change
    create_table :drinks do |t|
      t.integer :individual_id
      t.integer :food_id
      t.integer :unit_it
      t.float :amount
      t.datetime :consumed_at
    end  # do
  end  # change
    
  def self.up
    add_index :drinks, [:individual_id], :name => :idx_drinks_individual
    add_index :drinks, [:consumed_at], :name => :idx_drinks_when
  end  # up
end  # class
