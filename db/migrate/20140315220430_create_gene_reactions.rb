class CreateGeneReactions < ActiveRecord::Migration
  def change
    create_table :gene_reactions do |t|
      t.integer :pathway_id
      t.integer :reaction_id
      t.integer :gene_id
      t.integer :role_itype_id
    end  # do
  end  # change
  
  def self.up
    add_index :gene_reactions, [:pathway_id], :name => :idx_gene_reactions_pathway
    add_index :gene_reactions, [:gene_id], :name => :idx_gene_reactions_gene
  end  # up
end  # class
