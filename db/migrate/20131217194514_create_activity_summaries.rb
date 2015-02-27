class CreateActivitySummaries < ActiveRecord::Migration
  def change
    create_table :activity_summaries do |t|
      t.integer :individual_id
      t.integer :instrument_id
      t.integer :sleep_id
      t.integer :image_id
      t.integer :itype_id
      t.string :name
      t.string :qualifier
      t.float :amount
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :is_public
    end  # do
  end  # change
    
  def self.up
    add_index :activity_summaries, [:individual_id], :name => :idx_activity_sum_individual
    add_index :activity_summaries, [:start_time], :name => :idx_activity_sum_start
  end  # up
end  # class
