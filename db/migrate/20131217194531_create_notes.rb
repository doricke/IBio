class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :comment, :limit => 2048
    end  # do
  end  # change
end  # class
