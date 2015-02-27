class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
      t.string :pmid, :limit => 16
      t.string :doi, :limit => 160
      t.string :title, :limit => 480
      t.string :authors, :limit => 480
      t.string :reference, :limit => 240
    end  # do
  end  # change
end  # class
