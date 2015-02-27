class CreateRelateds < ActiveRecord::Migration
  def change
    create_table :relateds do |t|
      t.integer :family_id
      t.integer :itype_id
      t.string :guid1a, :limit => 32
      t.string :guild1b, :limit => 32
      t.string :relation, :limit => 64
      t.float :related
    end  # do
  end  # change
    
  def self.up
    add_index :relateds, [:family_id], :name => :idx_related_family
  end  # up
end  # class
