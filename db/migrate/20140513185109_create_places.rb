class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :city, :limit => 80
      t.string :state, :limit => 40
      t.float :longitude
      t.float :latitude
    end  # do
  end  # change
  
  def self.up
    add_index :places, [:city], :name => :idx_places_city
    add_index :places, [:state], :name => :idx_places_state
  end  # up
end  # class