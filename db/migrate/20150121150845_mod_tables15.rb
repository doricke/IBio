class ModTables15 < ActiveRecord::Migration
  def change
    add_column :monitor_data, :epoch_id, :integer
    add_column :monitor_data, :time_vector, :text
    add_column :activity_summaries, :group_id, :integer
    add_column :itypes, :unit_id, :integer
  end  # change
end  # class
