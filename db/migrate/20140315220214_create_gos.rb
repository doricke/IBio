class CreateGos < ActiveRecord::Migration
  def change
    create_table :gos do |t|
      t.integer :gene_id
      t.integer :itype_id
      t.string :term, :limit => 80
      t.string :pubmed, :limit => 10
    end  # do
  end  # change
  
  def self.up
    add_index :gos, [:gene_id], :name => :idx_go_gene
  end  # up
end  # class
