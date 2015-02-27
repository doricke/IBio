class ModTables14 < ActiveRecord::Migration
  def change
    change_column :conservations, :level, :float
  end
end
