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

class BasisFileLoader
  
  ###############################################################################
  def load_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.where( name: "Basis watch" ).take
    
    itype = Itype.where( name: "Basis" ).take
    
    basis_loader = BasisLoader.new
    contents, attachment_id = basis_loader.loadFile( filename, individual.id, instrument.id, itype.id )
    basis_loader.load_contents( contents, individual.id, instrument.id, attachment_id )
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = BasisFileLoader.new
  if ARGV.length >= 2
    app.load_data( ARGV[0], ARGV[1].delete( '"' ) )
  end  # if
end  # main_method

main_method
