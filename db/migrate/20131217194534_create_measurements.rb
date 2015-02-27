class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :individual_id
      t.integer :itype_id
      t.integer :unit_id
      t.integer :normal_id
      t.integer :panel_id
      t.integer :note_id
      t.string :name, :limit => 80
      t.datetime :created_at
      t.float :result
    end  # do
  end  # change
    
  def self.up
    add_index :measurements, [:individual_id], :name => :idx_measurements_individual
  end  # up
end  # class
