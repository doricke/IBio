class CreateEpoches < ActiveRecord::Migration
  def change
    create_table :epoches do |t|
      t.integer :year
      t.integer :month
      t.integer :day
      t.integer :hour
      t.integer :minute
      t.integer :second
      t.integer :usec

      t.timestamps
    end
  end
end
