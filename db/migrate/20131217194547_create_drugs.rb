class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.integer :note_id
        t.string :name, :limit => 80
    end  # do
  end  # change
    
  def self.up
    add_index :drugs, [:name], :name => :idx_drugs_name
  end  # up
end  # class
