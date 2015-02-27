class ModTables16 < ActiveRecord::Migration
  def change
      add_column :foods, :sodium, :float
      add_column :foods, :sugars, :float
      add_column :foods, :fiber, :float
  end  # change
end  # class
