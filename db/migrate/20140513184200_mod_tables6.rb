class ModTables6 < ActiveRecord::Migration
  def change
    add_column :drinks, :calories, :float
    add_column :foods, :itype_id, :integer
    add_column :foods, :cholesterol, :float
    add_column :foods, :saturated_fat, :float
    add_column :foods, :weight, :float
  end  # change
end  # class
