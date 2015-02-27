class CreatePathways < ActiveRecord::Migration
  def change
    create_table :pathways do |t|
      t.string :name, :limit => 160
    end  # do
  end  # change
  
  def self.up
    add_index :pathways, [:name], :name => :idx_pathways_name
  end  # up
end  # class
