class CreateMsas < ActiveRecord::Migration
  def change
    create_table :msas do |t|
      t.integer :gene_id
      t.string :name, :limit => 80
      t.string :category, :limit => 40
      t.string :description, :limit => 80
      t.string :msa_type, :limit => 4
      t.datetime :updated_at
    end  # do
  end  # change
    
  def self.up
    add_index :msas, [:gene_id], :name => :idx_msas_gene
  end  # up
end  # class
