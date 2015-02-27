class CreateSickSymptoms < ActiveRecord::Migration
  def change
    create_table :sick_symptoms do |t|
      t.integer :sick_id
      t.integer :symptom_id
      t.string :guid1, :limit => 32
      t.datetime :start_time
      t.datetime :end_time
      t.float :measurement
    end  # do
  end  # change
    
  def self.up
    add_index :sick_symptoms, [:sick_id], :name => :idx_sick_symptoms_sick
    add_index :sick_symptoms, [:guid1], :name => :idx_sick_symptoms_guid1
  end  # up
end  # class
