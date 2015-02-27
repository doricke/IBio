class ModTables7 < ActiveRecord::Migration
  def change
    add_column :experiments, :individual_id, :integer
    add_column :experiments, :attachment_id, :integer
  end  # change
end  # class
