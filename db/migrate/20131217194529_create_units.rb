class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name, :limit => 32
    end  # do
  end  # change
    
  def self.up
    add_index :units, [:name], :name => :idx_units_name
  end  # up
end  # class
