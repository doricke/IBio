class CreateDiseaseGenes < ActiveRecord::Migration
  def change
    create_table :disease_genes do |t|
      t.integer :disease_id
      t.integer :gene_id
    end  # do
  end  # change
    
  def self.up
    add_index :disease_genes, [:disease_id], :name => :idx_disease_genes_disease
    add_index :disease_genes, [:gene_id], :name => :idx_disease_genes_gene
  end  # up
end  # class
