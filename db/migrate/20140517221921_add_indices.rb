class AddIndices < ActiveRecord::Migration
  def change
    add_index :places, [:city, :state], :name => :idx_places_city_state
    add_index :airs, [:itype_id, :place_id, :sampled_at], :name => :idx_airs_sample
  end  # change
end  # class
