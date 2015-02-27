class CreateItypes < ActiveRecord::Migration
  def change
    create_table :itypes do |t|
      t.string :name, :limit => 80
      t.string :category, :limit => 32
    end  # do
  end  # change
    
  def self.up
    add_index :itypes, [:name], :name => :idx_itypes_name
    add_index :itypes, [:category], :name => :idx_itypes_category
  end  # up
end  # class
