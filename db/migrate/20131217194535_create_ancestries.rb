class CreateAncestries < ActiveRecord::Migration
  def change
    create_table :ancestries do |t|
      t.integer :individual_id
      t.integer :instrument_id
      t.integer :itype_id
      t.integer :ethnic_id
      t.float :percent
    end  # do
  end  # change
    
  def self.up
    add_index :ancestries, [:individual_id], :name => :idx_ancestries_individual
  end  # up
end  # class
