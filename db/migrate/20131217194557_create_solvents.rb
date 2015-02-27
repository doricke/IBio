class CreateSolvents < ActiveRecord::Migration
  def change
    create_table :solvents do |t|
      t.integer :biosequence_id
      t.integer :position
      t.float :accessibility
    end  # do
  end  # change
    
  def self.up
    add_index :solvents, [:biosequence_id], :name => :idx_solvents_biosequence
  end  # up
end  # class
