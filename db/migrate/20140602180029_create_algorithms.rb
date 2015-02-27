class CreateAlgorithms < ActiveRecord::Migration
  def change
    create_table :algorithms do |t|
      t.string :algorithm_name, :limit => 80
      t.string :version, :limit => 40
      t.datetime :updated_at
    end
  end
end
