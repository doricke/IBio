class CreateVocals < ActiveRecord::Migration
  def change
    create_table :vocals do |t|
      t.integer :individual_id
      t.integer :attachment_id
      t.string :speech_text, :limit => 2000
      t.datetime :start_time
    end  # do
  end  # change
  
  def self.up
    add_index :vocals, [:individual_id], :name => :idx_vocals_individuals
    add_index :vocals, [:attachment_id], :name => :idx_vocals_attachments
  end  # up
end  # class
