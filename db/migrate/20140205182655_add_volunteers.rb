class AddVolunteers < ActiveRecord::Migration
  def change
    Individual.create(sex: 'F', code_name: "A", data_entry_id: "101")
    Individual.create(sex: 'M', code_name: "B", data_entry_id: "102")
  end  # change
end  # class
