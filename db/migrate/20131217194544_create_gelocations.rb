class CreateGelocations < ActiveRecord::Migration
  def change
    create_table :gelocations do |t|
      t.integer :individual_id
      t.float :logitude
      t.float :latitude
      t.datetime :timepoint
    end  # do
  end  # change
    
  def self.up
    add_index :geolocations, [:individual_id], :name => :idx_geolocations_individual
  end  # up
end  # class
