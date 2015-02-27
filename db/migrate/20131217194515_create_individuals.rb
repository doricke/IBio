class CreateIndividuals < ActiveRecord::Migration
  def change
    create_table :individuals do |t|
      t.string :sex, :limit => 1
      t.string :code_name, :limit => 64
      t.string :guid1, :limit => 32
      t.string :guid2, :limit => 32
      t.string :password_hash, :limit => 64
      t.string :password_salt, :limit => 64
      t.string :data_entry_id, :limit => 32
      t.boolean :is_public
      t.boolean :is_admin
    end  # do
  end  # change
    
  def self.up
    add_index :individuals, [:code_name], :name => :idx_individuals_codename
    add_index :individuals, [:guid1], :name => idx_individuals_guid1
    add_index :individuals, [:guid2], :name => idx_individuals_guid2
  end  # up
end  # class
