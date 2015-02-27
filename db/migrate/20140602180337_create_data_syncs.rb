class CreateDataSyncs < ActiveRecord::Migration
  def change
    create_table :data_syncs do |t|
      t.integer :individual_id
      t.integer :instrument_id
      t.integer :algorithm_id
      t.datetime :updated_at
    end  # do
  end  # change
  
  def self.up
    add_index :data_syncs, [:individual_id], :name => :idx_datasyncs_individual
  end  # up

end  # class
