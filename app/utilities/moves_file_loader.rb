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

class MovesFileLoader
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    basis_file = InputFile.new(filename)
    basis_file.open_file
    contents = basis_file.read_file
    basis_file.close_file
    
    individual = Individual.find_by_code_name( "Gimley" )
    
    instrument = Instrument.find_by_name( "Android Phone" )
    
    itype = Itype.find_by_name( "Moves app" )
    
    attachment = Attachment.create(individual_id: individual.id, instrument_id: instrument.id, itype_id: itype.id, name: filename, content_type: "application/json", file_text: contents, is_parsed: true, created_at: Time::now)
    
    basis_loader = MovesLoader.new
    basis_loader.load_contents( contents, individual.id, instrument.id, attachment.id )
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = MovesFileLoader.new
  if ARGV.length >= 1
    app.load_data( ARGV[0] )
  else
    app.load_data( "data/Darrell_Moves_03252014.json" )
  end  # if
end  # main_method

main_method
