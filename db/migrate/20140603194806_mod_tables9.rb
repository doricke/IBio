class ModTables9 < ActiveRecord::Migration
  def change
    add_column :variants, :note_id, :integer
  
    add_index :notes, [:table_name, :comment], :name => :idx_notes_both
  end
end
