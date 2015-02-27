class CreateBiosequences < ActiveRecord::Migration
  def change
    create_table :biosequences do |t|
      t.integer :source_id
      t.integer :gene_id
      t.integer :organism_id
      t.string :name, :limit => 45
      t.integer :copy_number
      t.string :exons, :limit => 480
      t.string :aa_sequence, :limit => 2000
      t.text :mrna_sequence
      t.datetime :updated_at
    end  # do
  end  # change
    
  def self.up
    add_index :biosequences, [:name], :name => :idx_biosequences_name
  end  # up
end  # class
