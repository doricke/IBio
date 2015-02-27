class ModTables12 < ActiveRecord::Migration
  def change
    add_column :airs, :note_id, :integer
    add_column :group_members, :itype_id, :integer
    add_column :variants, :instrument_id, :integer
    add_column :variants, :quality, :float
  end  # change
end  # class
