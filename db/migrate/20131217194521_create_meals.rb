class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :individual_id
      t.datetime :consumed_at
    end  # do
  end  # change
    
  def self.up
    add_index :meals, [:individual_id], :name => :idx_meals_individual
  end  # up
end  # class
