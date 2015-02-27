class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.integer :biosequence_id
      t.integer :disease_id
      t.string :guid2, :limit => 32
      t.string :sequence_type, :limit => 4
      t.string :mutation, :limit => 20
      t.string :mutation_type, :limit => 8
      t.integer :sequence_start
      t.integer :sequence_end
    end  # do
  end  # change
    
  def self.up
    add_index :variants, [:guid2], :name => :idx_variants_guid2
    add_index :variants, [:biosequence_id], :name => :idx_variants_biosequence
    add_index :variants, [:disease_id], :name => :idx_variants_disease
  end  # up
end  # class
