class CreateAlleleCalls < ActiveRecord::Migration
  def change
    create_table :allele_calls do |t|
      t.integer :locus_id
      t.integer :experiment_id
      t.string :guid2, :limit => 32
      t.string :alleles, :limit => 4
    end  # do
  end  # change
    
  def self.up
    add_index :allele_calls, [:locus_id], :name => :idx_allele_calls_locus
    add_index :allele_calls, [:experiment_id], :name => :idx_allele_calls_experiment
    add_index :allele_calls, [:guid2], :name => :idx_allele_calls_guid2
  end  # up
end  # class
