class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :individual_id
      t.integer :activity_id
      t.string :name, :limit => 80
      t.string :content_type, :limit => 80
      t.datetime :created_at
      t.string :image_type, :limit => 32
      t.binary :image_blob, :limit => 15.megabyte
    end  # do
  end  # change
    
  def self.up
    add_index :images, [:individual_id], :name => :idx_images_individual
  end  # up
end  # class
