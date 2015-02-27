class CreateGenes < ActiveRecord::Migration
  def change
    create_table :genes do |t|
      t.integer :note_id
      t.string :pharm_gkb_id, :limit => 16
      t.string :name, :limit => 80
      t.string :ncbi_gene_id, :limit => 12
      t.string :gene_symbol, :limit => 40
      t.string :description, :limit => 240
      t.string :synonyms, :limit => 240
      t.string :chromosome, :limit => 2
      t.integer :chromosome_start
      t.integer :chromosome_end
      t.boolean :cpic_dosing
      t.datetime :updated_at
    end  # do
  end  # change
    
  def self.up
    add_index :genes, [:name], :name => :idx_genes_name
  end  # up
end  # class
