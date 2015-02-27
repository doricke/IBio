class CreateGroupActivities < ActiveRecord::Migration
  def change
    create_table :group_activities do |t|
      t.integer :group_id
      t.integer :activity_id
    end  # do
  end  # change
    
    def self.up
    add_index :group_activities, [:group_id], :name => :idx_group_activities_group
end  # up
end  # class
