class CreateIevents < ActiveRecord::Migration
  def change
    create_table :ievents do |t|
      t.integer :individual_id
      t.integer :activity_id
      t.integer :itype_id
      t.string :name, :limit => 80
      t.datetime :start_time
      t.datetime :end_time
    end  # do
  end  # change
    
  def self.up
    add_index :ievents, [:indiviudal_id], :name => :idx_ievents_individual
  end  # up
end  # class
