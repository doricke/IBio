class CreatePanels < ActiveRecord::Migration
  def change
    create_table :panels do |t|
      t.integer :individual_id
      t.integer :attachment_id
      t.integer :itype_id
      t.datetime :start_time
      t.datetime :end_time
    end  # do
  end  # change
    
  def self.up
    add_index :panels, [:individual_id], :name => :idx_panels_individual
  end  # up
end  # class
