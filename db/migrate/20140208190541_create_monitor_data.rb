class CreateMonitorData < ActiveRecord::Migration
  def change
    create_table :monitor_data do |t|
      t.integer :instrument_id
      t.integer :individual_id
      t.integer :attachment_id
      t.integer :image_id
      t.integer :itype_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :points_per_second
      t.integer :points_per_hour
      t.text :data_vector
    end  # do
  end  # change
  
  
  def self.up
    add_index :monitor_data, [:individual_id], :name => :idx_monitor_data_individual
  end  # up
  
end  # class
