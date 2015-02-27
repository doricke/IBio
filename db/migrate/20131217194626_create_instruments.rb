class CreateInstruments < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.string :name, :limit => 80
      t.string :instrument_type, :limit => 40
    end  # do
  end  # change
    
  def self.up
    add_index :instruments, [:name], :name => :idx_instruments_name
    add_index :instruments, [:instrument_type], :name => :idx_instruments_type
  end  # up
end  # class
