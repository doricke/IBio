class CreateEthnics < ActiveRecord::Migration
  def change
    create_table :ethnics do |t|
      t.string :name, :limit => 80
      t.string :region, :limit => 80
      t.string :race, :limit => 80
    end  # do
  end  # change
    
  def self.up
    add_index :ethnics, [:name], :name => :idx_ethnics_name
  end  # up
end  # class
