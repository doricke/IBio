require 'input_file.rb'

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

class FoodLoader
  
  ###############################################################################
  def load_item( category, food, units, calories )
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
  def load_contents( contents )
    lines = contents.split( "\n" )
    lines.each do |line|
      tokens = line.split( "\t" )
      if ( tokens[0] != "category" )
        category = tokens[0]
        food = tokens[1].delete( "\"" )
        units = tokens[2]
        calories = tokens[3].to_f
        load_item( category, food, units, calories )
      end  # if
    end  # do
  end  # load_contents
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    food_file = InputFile.new(filename)
    food_file.open_file
    contents = food_file.read_file
    food_file.close_file
    load_contents( contents )
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method( filename )
  app = FoodLoader.new
  if ARGV.length >= 1
    app.load_data( ARGV[0] )
  else
    app.load_data( filename )
  end  # if
end  # main_method

main_method( "food.txt" )
