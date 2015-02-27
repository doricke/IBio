class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name, :limit => 80
      t.float :calories
      t.float :protein
      t.float :fats
      t.float :amount
      t.integer :unit_id
    end  # do
  end  # change
    
  def self.up
    add_index :foods, [:name], :name => :idx_foods_name
  end  # up
end  # class
