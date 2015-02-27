class CreateEffects < ActiveRecord::Migration
  def change
    create_table :effects do |t|
      t.integer :biosequence_id
      t.integer :variant_id
      t.string :name, :limit => 40
      t.string :impact, :limit => 10
      t.string :function_class, :limit => 10
      t.string :codon_change, :limit => 40
      t.string :aa_change, :limit => 40
    end  # do
  end  # change
  
  def self.up
    add_index :effects, [:biosequence_id], :name => :idx_biosequence_effects
    add_index :effects, [:variant_id], :name => :idx_variant_effects
  end  # up
  
end  # class
