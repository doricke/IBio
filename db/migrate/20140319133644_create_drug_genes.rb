class CreateDrugGenes < ActiveRecord::Migration
  def change
    create_table :drug_genes do |t|
      t.integer :drug_id
      t.integer :gene_id
      # t.boolean :cpic_dosing
      t.string :pharm_gkb_id, :limit => 16
    end  # do
  end  # change
  
  def self.up
    add_index :drug_genes, [:drug_id], :name => :idx_drug_genes_drug
    add_index :drug_genes, [:gene_id], :name => :idx_drug_genes_gene
  end  # up
end  # class
