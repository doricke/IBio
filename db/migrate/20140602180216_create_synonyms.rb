class CreateSynonyms < ActiveRecord::Migration
  def change
    create_table :synonyms do |t|
      t.integer :itype_id
      t.integer :source_id
      t.string :synonym_name, :limit => 80
      t.string :table_name, :limit => 40
    end  # do
  end  # change
  
  def self.up
    add_index :synonyms, [:table_name], :name => :idx_synonyms_tablename
  end  # up

end  # class
