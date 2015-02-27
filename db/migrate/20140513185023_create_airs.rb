class CreateAirs < ActiveRecord::Migration
  def change
    create_table :airs do |t|
      t.integer :place_id
      t.integer :itype_id
      t.float :air_value
      t.datetime :sampled_at
    end  # do
  end  # change
  
  def self.up
    add_index :airs, [:place_id], :name => :idx_airs_place
    add_index :airs, [:place_id, :itype_id], :name => :idx_airs_place_itype
  end  # up
end  # class