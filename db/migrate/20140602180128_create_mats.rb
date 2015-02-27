class CreateMats < ActiveRecord::Migration
  def change
    create_table :mats do |t|
      t.integer :individual_id
      t.integer :vocal_id
      t.integer :attachment_id
      t.integer :algorithm_id
      t.float :score
      t.datetime :start_time
      t.datetime :updated_at
    end
  end
  
  def self.up
    add_index :mats, [:individual_id], :name => :idx_mats_individual
    add_index :mats, [:vocal_id], :name => :idx_mats_vocal
    add_index :mats, [:algorithm_id], :name => :idx_mats_algorithm
  end  # up

end  # class
