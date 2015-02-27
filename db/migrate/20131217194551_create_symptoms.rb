class CreateSymptoms < ActiveRecord::Migration
  def change
    create_table :symptoms do |t|
      t.string :name, :limit => 80
    end  # do
  end  # change
    
  def self.up
    add_index :symptoms, [:name], :name => :idx_symptoms_name
  end  # up
end  # class
