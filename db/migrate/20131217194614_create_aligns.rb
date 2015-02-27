class CreateAligns < ActiveRecord::Migration
  def change
    create_table :aligns do |t|
      t.integer :msa_id
      t.integer :biosequence_id
      t.integer :align_rank
      t.datetime :updated_at
      t.string :align_sequence, :limit => 4800
    end  # do
  end  # change
    
  def self.up
    add_index :aligns, [:msa_id], :name => :idx_aligns_msa
    add_index :aligns, [:biosequence_id], :name => :idx_aligns_biosequence
  end  # up
end  # class
