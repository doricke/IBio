class CreatePrescriptions < ActiveRecord::Migration
  def change
    create_table :prescriptions do |t|
      t.integer :drug_id
      t.integer :unit_it
      t.string :guid1, :limit => 32
      t.float :dose
      t.float :daily
      t.datetime :start_time
      t.datetime :end_time
    end  # do
  end  # change
    
  def self.up
    add_index :prescriptions, [:guid1], :name => :idx_prescriptions_guid1
  end  # up
end  # class
