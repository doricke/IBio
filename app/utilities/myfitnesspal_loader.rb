require 'input_file.rb'
require 'text_tools.rb'

################################################################################
# Copyright (C) 2015  Darrell O. Ricke, PhD
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
################################################################################

class MyfitnesspalLoader
  
  ###############################################################################
  def load_item( individual_id, date, meal, food, amount, units, calories, carbs, fat, protein, cholest, sodium, sugars, fiber )
      
    puts "date: #{date} #{meal} #{food} amount: #{amount} units: #{units} calories: #{calories} carbs: #{carbs} fat: #{fat} protein: #{protein} cholest: #{cholest} sodium: #{sodium} sugar: #{sugars} fiber #{fiber}"
    return
    
    # Set up the Unit entry.
    units_id = nil
    amount = 1.0
    if ( units.size > 0 )
      tokens = units.split( " " )
      amount = tokens[0].to_f if tokens.size >= 2
      units_rec = Unit.find_by_name( tokens[1] )
      units_rec = Unit.create( name: tokens[1] ) if units_rec.nil?
      units_id = units_rec.id
    end  # if
    
    # Set up the food category.
    itype_id = nil
    if ( category.size > 0 )
      itype = Itype.find_by_name( category )
      itype = Itype.create(name: category, category: "food") if itype.nil?
      itype_id = itype.id
    end  # if
    
    food_item = Food.where(name: food).first_or_create.update_attributes(unit_id: units_id, itype_id: itype_id, name: food, calories: calories, amount: amount )
    
  end  # load_item
  
  ###############################################################################
  def load_contents( contents, individual_id )
    lines = contents.split( "\n" )
    date = Time::now
    meal = ""
    lines.each do |line|
      puts "line: #{line}"
      tokens = TextTools.csv_split( line )
      # Check for new date
      if line.include?( ",,,,,,,," ) && (tokens[0].size > 0 )
        if (tokens[0] == "Breakfast") || (tokens[0]=="Lunch") || (tokens[0]=="Dinner") || (tokens[0]=="Snacks")
          meal = tokens[0]
          # puts "meal: #{meal}"
        else
          date = tokens[0]
          # puts "date: #{date}"
        end  # if
      end  # if
      
      if ( tokens[0].size > 0 ) && ( line[0] == '"' )
        parts = tokens[0].split( "," )
        food = parts[0]
        # puts "food: #{food}, parts[1]: '#{parts[1]}'"
        amount = parts[1].to_f
        space = parts[1][ 1..-1 ].index( " " )
        units = ""
        units = parts[1][ (space+1)..-1 ] if ! space.nil?
        calories = tokens[1].to_f
        carbs = tokens[2].to_f
        fat = tokens[3].to_f
        protein = tokens[4].to_f
        cholest = tokens[5].to_f
        sodium = tokens[6].to_f
        sugars = tokens[7].to_f
        fiber = tokens[8].to_f
        load_item( individual_id, date, meal, food, amount, units, calories, carbs, fat, protein, cholest, sodium, sugars, fiber )
      end  # if
    end  # do
  end  # load_contents
  
  ###############################################################################
  def load_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    food_file = InputFile.new(filename)
    food_file.open_file
    contents = food_file.read_file
    food_file.close_file
    load_contents( contents, individual.id )
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method()
  puts "main_method called"
  app = MyfitnesspalLoader.new
  if ARGV.length >= 2
    app.load_data( ARGV[0], ARGV[1] )
  else
    puts "Usage: rails runner app/utilities/myfitnesspal_loader.rb file.csv id_no"
  end  # if
end  # main_method

###############################################################################

main_method()
