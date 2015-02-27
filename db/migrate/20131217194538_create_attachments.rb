class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :individual_id
      t.integer :instrument_id
      t.integer :attachment_id
      t.integer :itype_id
      t.string :name, :limit => 120
      t.string :content_type, :limit => 80
      t.string :file_path, :limit => 240
      t.boolean :is_parsed
      t.datetime :created_at
      t.text :file_text, :limit => 127.megabyte
      t.binary :file_binary, :limit => 127.megabyte
    end  # do
  end  # change
    
  def self.up
    add_index :attachments, [:individual_id], :name => :idx_attachments_individual
  end  # up
end  # class
