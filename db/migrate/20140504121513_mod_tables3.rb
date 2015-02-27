class ModTables3 < ActiveRecord::Migration
  def change
    add_column :structure_sequences, :resolution, :string, :limit => 8
    add_column :structure_sequences, :aa_start, :integer
    add_column :structure_sequences, :aa_end, :integer
    
    add_column :variants, :is_public, :boolean
    
    add_column :vocals, :name, :string, :limit => 120
    
    change_column :attachments, :name, :string, :limit => 120
    
    change_column :genes, :synonyms, :string, :limit => 240
    
    change_column :vocals, :speech_text, :string, :limit => 2000
    
    add_index :attachments, [:individual_id, :name], :name => :idx_attachments_both
    add_index :itypes, [:name, :category], :name => :idx_itypes_both
    add_index :genes, [:organism_id, :name], :name => :idx_genes_org_name
    add_index :biosequence_domains, [:biosequence_id, :domain_id], :name => :idx_seq_domains_both
    add_index :diseases, [:mim_id], :name => :idx_diseases_mim
    add_index :disease_genes, [:disease_id, :gene_id], :name => :idx_disease_gene_both
    add_index :structure_sequences, [:structure_id, :biosequence_id, :chain], :name => :idx_structure_seq_triple
    add_index :biosequences, [:organism_id, :gene_id], :name => :idx_biosequences_org_gene
    
  end  # change
end  # class
