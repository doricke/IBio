class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :individual_id
      t.integer :itype_id
      t.integer :image_id
      t.integer :attachment_id
      t.integer :note_id
      t.string :activity_name, :limit => 80
      t.datetime :start_time
      t.datetime :end_time
      t.integer :intensity
      t.string :qualifier, :limit => 32
    end  # do
  end  # change
    
    def self.up
    add_index :activities, [:individual_id], :name => :idx_activities_individual
end  # up
end  # class
