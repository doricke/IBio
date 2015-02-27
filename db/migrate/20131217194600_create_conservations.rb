class CreateConservations < ActiveRecord::Migration
  def change
    create_table :conservations do |t|
      t.integer :biosequence_id
      t.integer :position
      t.string :level, :limit => 8
    end  # do
  end  # change
    
  def self.up
    add_index :conservations, [:biosequence_id], :name => :idx_conservations_biosequence
  end  # up
end  # class
