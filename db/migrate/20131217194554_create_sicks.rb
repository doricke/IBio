class CreateSicks < ActiveRecord::Migration
  def change
    create_table :sicks do |t|
      t.integer :itype_id
      t.string :guid1, :limit => 32
      t.datetime :start_time
      t.datetime :end_time
    end  # do
  end  # change
    
  def self.up
    add_index :sicks, [:guid1], :name => :idx_sicks_guid1
  end  # up
end  # class
