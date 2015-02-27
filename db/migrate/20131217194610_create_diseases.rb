class CreateDiseases < ActiveRecord::Migration
  def change
    create_table :diseases do |t|
      t.integer :note_id
      t.string :mim_id, :limit => 8
      t.string :name, :limit => 80
    end  # do
  end  # change
    
  def self.up
    add_index :diseases, [:name], :name => :idx_diseases_name
  end  # up
end  # class
