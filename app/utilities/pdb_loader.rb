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

class PdbLoader
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    basis_file = InputFile.new(filename)
    basis_file.open_file
    contents = basis_file.read_file
    basis_file.close_file
    tokens = filename.split( '/' )
    pdb_name = tokens[0].split( '.' )
    
    structure = Structure.find_by_name( pdb_name[0] )
    if ! structure.nil?
      structure.pdb = contents
      structure.pdb_length = contents.size
      structure.save
    else
      Structure.Create(name: pdb_name[0], pdb_length: contents.size, pdb: contents)
    end  # if
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = PdbLoader.new
  if ARGV.length >= 1
    app.load_data( ARGV[0] )
  end  # if
end  # main_method

main_method
