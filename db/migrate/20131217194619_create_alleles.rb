class CreateAlleles < ActiveRecord::Migration
  def change
    create_table :alleles do |t|
      t.integer :locus_id
      t.integer :ethnic_id
      t.string :name, :limit => 40
      t.string :seq, :limit => 1024
      t.string :regular_expression, :limit => 1024
      t.float :allele_frequency
    end  # do
  end  # change
    
  def self.up
    add_index :alleles, [:locus_id], :name => :idx_alleles_locus
  end  # up
end  # class
