class ModTables5 < ActiveRecord::Migration
  def change
    add_column :sources, :table_name, :string, :limit => 40
    add_column :notes, :table_name, :string, :limit => 40
    
    change_column :structures, :pdb, :text, :limit => 31.megabyte

    add_index :drug_reactions, [:pathway_id], :name => :idx_drug_reactions_pathway
    add_index :individuals, [:data_entry_id], :name => :idx_individuals_data_entry_id
    add_index :attachments, [:name], :name => :idx_attachments_name
    add_index :instruments, [:name], :name => :idx_instruments_name
    add_index :notes, [:comment], :name => :idx_notes_comment
    add_index :genes, [:ncbi_gene_id], :name => :idx_genes_ncbi_gene_id
    add_index :genes, [:gene_symbol], :name => :idx_genes_symbol
  end  # change
end  # class
