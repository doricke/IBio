class CreateMetaprofiles < ActiveRecord::Migration
  def change
    create_table :metaprofiles do |t|
      t.integer :organism_id
      t.string :guid1, :limit => 32
      t.integer :count
      t.datetime :measured_at
    end  # do
  end  # change
    
  def self.up
    add_index :metaprofiles, [:guid1], :name => :idx_metaprofiles_guid1
  end  # up
end  # class
