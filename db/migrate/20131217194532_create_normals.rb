class CreateNormals < ActiveRecord::Migration
  def change
    create_table :normals do |t|
      t.integer :itype_id
      t.integer :ethnic_id
      t.integer :note_id
      t.float :normal_low
      t.float :normal_high
      t.string :ref_range, :limit => 32
      t.string :sex, :limit => 1
      t.integer :age_low
      t.integer :age_high
    end  # do
  end  # change
end  # class
