class CreateBiosequenceDomains < ActiveRecord::Migration
  def change
    create_table :biosequence_domains do |t|
      t.integer :biosequence_id
      t.integer :domain_id
      t.integer :seq_start
      t.integer :seq_end
    end  # do
  end  # change
    
  def self.up
    add_index :biosequence_domains, [:biosequence_id], :name => :idx_biosequence_domains_sequence
    add_index :biosequence_domains, [:domain_id], :name => :idx_biosequence_domains_domain
  end  # up
end  # class
