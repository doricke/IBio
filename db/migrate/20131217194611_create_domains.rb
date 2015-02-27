class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.integer :note_id
      t.string :name, :limit => 80
    end  # do
  end  # change
    
  def self.up
    add_index :domains, [:name], :name => :idx_domains_name
  end  # up
end  # class
