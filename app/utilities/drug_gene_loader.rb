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

class GeneInfoLoader
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    info_file = InputFile.new(filename)
    info_file.open_file
    # contents = info_file.read_file
    while ( info_file.is_end_of_file? == false )
      line = info_file.next_line()
      process_line( line ) if ( info_file.is_end_of_file? == false )
    end  # while
    info_file.close_file
    
    # load_contents( contents )
  end #load_infos
  
  ###############################################################################
  def load_contents( contents )
    lines = contents.split( "\n" )
    for i in 1...lines.length do
      process_line( lines[i] )
    end  # for
  end  # load_contents
  
  ###############################################################################
  def process_line( line )
    tokens = line.split( "\t" )
    
    Gene.create(name: tokens[2], ncbi_gene_id: tokens[1], gene_symbol: tokens[2], synonyms: tokens[3], chromosome: tokens[6], 
        description: tokens[8] ) if tokens[9] != "pseudo"
    
  end #process line
  
end #class

###############################################################################

def main_method
  app = GeneInfoLoader.new
  app.load_data( "data/gene_info.hs" )
end  # main_method

main_method
