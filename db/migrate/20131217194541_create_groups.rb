class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, :limit => 80
    end  # do
  end  # change
    
  def self.up
    add_index :groups, [:name], :name => :idx_groups_name
  end  # up
end  # class
