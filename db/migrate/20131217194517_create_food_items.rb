class CreateFoodItems < ActiveRecord::Migration
  def change
    create_table :food_items do |t|
      t.integer :individual_id
      t.integer :meal_id
      t.integer :food_id
      t.integer :unit_id
      t.float :amount
      t.float :calories
    end  # do
  end  # change
    
  def self.up
    add_index :food_items, [:individual_id], :name => :idx_food_items_individual
    add_index :food_items, [:meal_id], :name => :idx_food_items_meal
  end  # up
end  # class
