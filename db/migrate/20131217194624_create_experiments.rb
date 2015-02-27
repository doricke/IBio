class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.integer :instrument_id
      t.integer :itype_id
      t.integer :note_id
      t.string :name, :limit => 80
      t.datetime :created_at
    end  # do
  end  # change
    
  def self.up
    add_index :experiments, [:name], :name => :idx_experiments_name
    add_index :experiments, [:created_at], :name => :idx_experiments_when
  end  # up
end  # class
