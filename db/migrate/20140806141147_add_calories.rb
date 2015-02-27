class AddCalories < ActiveRecord::Migration
  def change
    add_column :activity_summaries, :calories, :float
  end  # change
end  # class
