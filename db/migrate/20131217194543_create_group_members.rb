class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members do |t|
      t.integer :group_id
      t.integer :individual_id
    end  # do
  end  # change
    
  def self.up
    add_index :group_members, [:group_id], :name => :idx_group_members_group
    add_index :group_members, [:individual_id], :name => :idx_group_members_individual  
  end  # up
end  # class
