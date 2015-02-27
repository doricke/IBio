class CreateLocus < ActiveRecord::Migration
  def change
    create_table :locus do |t|
      t.integer :disease_id
      t.integer :gene_id
      t.integer :itype_id
      t.string :name, :limit => 40
      t.string :chromosome, :limit => 2
      t.integer :position
    end  # do
  end  # change
    
  def self.up
    add_index :locus, [:name], :name => :idx_locus_name
  end  # up
end  # class
