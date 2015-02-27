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

class ConservationLoader
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    conservation_file = InputFile.new(filename)
    conservation_file.open_file
    contents = conservation_file.read_file
    conservation_file.close_file

    parts = filename.split( "/" )

    tokens = parts[-1].split( "." )
    seq = Biosequence.where( name: tokens[0] ).take
    if seq.nil?
      puts "Sequence #{tokens[0]} not found"
      return
    end  # if

    load_contents( contents, seq )
  end #load_data
  
  ###############################################################################
  def load_contents( contents, seq )
      # puts "#### ConservationLoader called!!!!"
    lines = contents.split( "\n" )
    for i in 0...lines.length do
      process_line( lines[i], seq )
    end  # for
  end  # load_contents
  
  ###############################################################################
  def process_line( line, seq )
      # puts "#### line: #{line}, seq_id: #{seq.id}"
    tokens = line.split( "\t" )
    pos = tokens[0].to_i
 
    conservation = Conservation.where( biosequence_id: seq.id, position: pos ).first_or_create.
      update_attributes( biosequence_id: seq.id, position: pos, level: tokens[2].to_f )
  end #process line
  
end #class

###############################################################################

def main_method
  app = ConservationLoader.new
  if ARGV.length >= 1
    app.load_data( ARGV[0] )
  else
    puts "usage: rails runner app/utilities/conservation_loader.rb conservation.csv"
  end  # if
end  # main_method

main_method
