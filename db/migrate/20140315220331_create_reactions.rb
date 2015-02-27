class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.integer :pathway_id
      t.integer :itype_id
      t.integer :control_itype
      t.string :from, :limit => 80
      t.string :to, :limit => 80
      t.string :control, :limit => 80
      t.integer :rank
    end  # do
  end  # change
  
  def self.up
    add_index :reactions, [:pathway_id], :name => :idx_reactions_pathway
  end  # up
end  # class
