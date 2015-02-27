class CreateDataRanges < ActiveRecord::Migration
  def change
    create_table :data_ranges do |t|
      t.integer :itype_id
      t.string :table_name
      t.float :lower
      t.float :upper
      t.string :qualifier, limit: 40
      t.string :description, limit: 400
    end  # do
  end  # change
  
  def self.up
    add_index :data_ranges, [:table_name], :name => :idx_dataranges_tablename
    add_index :data_ranges, [:itype_id], :name => :idx_dataranges_itype
  end  # up

end  # class
