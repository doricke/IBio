class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :individual_id
      t.integer :activity_id
      t.float :latitude
      t.float :longitude
      t.integer :altitude
      t.integer :bearing
      t.float :speed
      t.datetime :created_at
    end  # do
  end  # change
  
  def self.up
    add_index :locations, [:individual_id], :name => :idx_location_individual
  end  # up
  
end  # class
