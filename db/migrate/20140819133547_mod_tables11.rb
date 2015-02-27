class ModTables11 < ActiveRecord::Migration
  def change
    change_column :monitor_data, :data_vector, :text, :limit => 31.megabyte
    
    add_index :monitor_data, [:individual_id, :itype_id], :name => :idx_monitor_data_device
  end  # change
end  # class
