class CreateSleeps < ActiveRecord::Migration
  def change
    create_table :sleeps do |t|
      t.integer :individual_id
      t.integer :instrument_id
      t.integer :image_id
      t.integer :note_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :light_sleep
      t.integer :deep_sleep
      t.integer :rem_sleep
      t.integer :secs_asleep
      t.integer :interruptions
      t.string :qualifier, :limit => 32
      t.string :wake_up, :limit => 1
    end  # do
  end  # change
    
  def self.up
    add_index :sleeps, [:individual_id], :name => :idx_sleep_individual
    add_index :sleeps, [:start_time], :name => :idx_sleep_start
  end  # up
end  # class
