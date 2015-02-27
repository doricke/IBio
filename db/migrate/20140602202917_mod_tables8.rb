class ModTables8 < ActiveRecord::Migration
  def change
    add_column :biosequences, :accession, :string, limit: 20
    
    add_column :pathways, :source_id, :integer
    add_column :pathways, :smpdb_id, :string, limit: 20
    
    add_column :drug_reactions, :source_id, :integer
    
    add_column :drug_genes, :source_id, :integer
    
    add_column :synonyms, :record_id, :integer
    
    add_index :drug_genes, [:drug_id, :gene_id], :name => :idx_drug_genes_both
    
    add_index :synonyms, [:table_name, :record_id, :synonym_name], :name => :idx_synonyms_triple
    
    add_index :drug_reactions, [:drug_id, :pathway_id], :name => :idx_drug_reactions_both
  end  # change
end  # class
