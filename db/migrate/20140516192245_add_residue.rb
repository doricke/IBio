class AddResidue < ActiveRecord::Migration
  def change
    add_column :atoms, :residue, :string, :limit => 1
  end  # change
end  # class
