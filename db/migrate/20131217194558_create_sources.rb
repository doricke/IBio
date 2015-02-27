class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name, :limit => 80
      # t.string :table_name, :limit => 40		# Added in following mod_table file
      t.datetime :updated_at
    end  # do
  end  # change
    
  def self.up
    add_index :sources, [:name], :name => :idx_sources_name
  end  # up
end  # class
