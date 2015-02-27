class AirUpdate < ActiveRecord::Migration
  def change
    add_column :airs, :unit_id, :integer
    add_column :places, :site_no, :integer
    
    add_index :places, [:site_no], :name => :idx_places_site_no
  end  # change
end  # class
