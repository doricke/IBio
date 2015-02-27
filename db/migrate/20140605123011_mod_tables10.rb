class ModTables10 < ActiveRecord::Migration
  def change
    change_column :devices, :wear_at, :string, :limit => 20
    change_column :devices, :serial_no, :string, :limit => 40
    
    add_index :devices, [:individual_id], :name => :idx_devices_individual
    add_index :devices, [:serial_no], :name => :idx_devices_serial_no
  
    add_column :monitor_data, :device_id, :integer
  end  # change
end  # class
