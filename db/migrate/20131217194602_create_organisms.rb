class CreateOrganisms < ActiveRecord::Migration
  def change
    create_table :organisms do |t|
      t.string :name, :limit => 80
      t.string :taxonomy, :limit => 480
    end  # do
  end  # change
    
  def self.up
    add_index :organisms, [:name], :name => :idx_organisms_name
  end  # up
end  # class
