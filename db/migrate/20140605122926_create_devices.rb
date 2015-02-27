class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :individual_id
      t.integer :instrument_id
      t.string :wear_at
      t.string :serial_no
    end
  end
end
