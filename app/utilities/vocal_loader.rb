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

class VocalLoader
  
  ###############################################################################
  def get_time( filename )
    name = filename.delete( "_" )
    puts "get_time: #{name}"
    year = name[ 0..3 ].to_i
    month = name[ 4..5 ].to_i
    day = name[ 6..7 ].to_i
    hour = name[ 8..9 ].to_i
    min = name[ 10..11 ].to_i
    sec = name[ 12..13 ].to_i
    usec = 0
    usec = name[ 15..17 ].to_i if (name[ 14 ] == '.') && (name[ 15 ] != 'w')
    puts "year: #{year}, mon: #{month}, day: #{day}, hour: #{hour}, min: #{min}, sec: #{sec}, usec: #{usec}"
    return Time::local( year, month, day, hour, min, sec, usec )
  end  # method get_time
  
  ###############################################################################
  def load_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    basis_file = InputFile.new(filename)
    basis_file.open_file
    contents = basis_file.read_binary
    basis_file.close_file
    
    parts = filename.split( '/' )
    
    individual = Individual.find_by_data_entry_id( data_entry_id )
    
    instrument = Instrument.find_by_name( "Microphone" )
    
    itype = Itype.find_by_name( "Voice" )
    
    recorded_at = get_time( parts[-1] )
    attachment = Attachment.where( name: parts[-1] ).take
    attachment = Attachment.create(individual_id: individual.id, instrument_id: instrument.id, itype_id: itype.id, name: parts[-1], content_type: "audio/wav", file_binary: contents, is_parsed: true, created_at: recorded_at ) if attachment.nil?
    
    Vocal.where(individual_id: individual.id, attachment_id: attachment.id ).first_or_create.update_attributes( individual_id: individual.id, attachment_id: attachment.id, start_time: recorded_at )
    
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = VocalLoader.new
  if ARGV.length >= 2
    app.load_data( ARGV[0], ARGV[1].delete( '"' ) )
  end  # if
end  # main_method

main_method
