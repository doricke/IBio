class CreateDrugReactions < ActiveRecord::Migration
  def change
    create_table :drug_reactions do |t|
      t.integer :drug_id
      t.integer :pathway_id
      t.integer :reaction_id
    end  # do
  end  # change
  
  def self.up
    add_index :drug_reactions, [:drug_id], :name => :idx_drug_reactions_drug
  end  # up
end  # class
