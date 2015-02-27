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

class ActigraphLoader
  
  ###############################################################################
  def process_header( header, instrument_id, individual_id )
    tokens = header[1].split( " " )
    puts "***** Warning **** Serial Number expected: #{header[1]}" if (tokens[0] != "Serial")
    serial_no = tokens[2]
    puts "Serial number: #{serial_no}"
    device = Device.where( serial_no: serial_no ).take
    device = Device.create( instrument_id: instrument_id, individual_id: individual_id, serial_no: serial_no ) if device.nil?
  
    tokens = header[2].split( " " )
    puts "***** Warning **** Start Time expected: #{header[2]}" if (tokens[1] != "Time")
    parts = tokens[2].split( ":" )
    hour = parts[0].to_i
    min = parts[1].to_i
    sec = parts[2].to_i
    
    tokens = header[3].split( " " )
    puts "***** Warning **** Start Date expected: #{header[3]}" if (tokens[1] != "Date")
    parts = tokens[2].split( "/" )
    month = parts[0].to_i
    day = parts[1].to_i
    year = parts[2].to_i
    
    start_time = Time::local( year, month, day, hour, min, sec )
    
    tokens = header[4].split( " " )
    parts = tokens[3].split( ":" )
    epoch = parts[2].to_i
    epoch = parts[1].to_i * 60 if (epoch < 0)
  
    return start_time, device, epoch
  end  # process_header
  
  ###############################################################################
  def process_data( lines, individual_id, instrument_id, attachment_id, itype_id, device_id, start_time, epoch )
    index_start = 10
    index_start = 11 if ( lines[ index_start ][ 0..3 ] == "Axis" )
    time_start = start_time
  
    delta_min = 59 - start_time.min
    delta_sec = 59 - start_time.sec
    index_end = (delta_min * 60 + delta_sec) * 100
    time_end = start_time + (delta_min * 60) + delta_sec
    # milliseconds = 0
    # block = ""
    while ( index_end < lines.size )
      if ( line[ index_start ] != "0,0,0" )
      
      end  # if
      
      puts "time_start: #{time_start} : #{time_end} index #{start_index} : #{index_end}"
      
      time_start = time_end +1
      delta_min = 59 - time_start.min
      delta_sec = 59 - time_start.sec
      index_end = (delta_min * 60 + delta_sec) * 100
      index_end = lines.size if index_end > lines.size
      time_end = time_start + (delta_min * 60) + delta_sec
    end  # while
    
    
  end  # process_data
  
  ###############################################################################
  def load_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.where( name: "Actigraph" ).take
    instrument = Instrument.create( name: "Actigraph", instrument_type: "Accelerometer" ) if instrument.nil?
    
    itype = Itype.where( name: "Actigraph" ).take
    itype = Itype.create( name: "Actigraph", category: "Health Monitor" ) if itype.nil?
    
    actigraph_file = InputFile.new( filename )
    actigraph_file.open_file
    contents = actigraph_file.read_file.delete( "\r" )
    actigraph_file.close_file
    filename_parts = filename.split( '/' )
    attachment = Attachment.where( name: parts[-1] ).take
    attachment = Attachment.create( individual_id: individual.id, instrument_id: instrument.id, itype_id: itype.id, name: parts[-1], content_type: "text/csv", file_text: contents, is_parsed: true ) if attachment.nil?

    lines = contents.split( "\n" )
    start_time, device, epoch = process_header( lines[0..20], instrument.id, individual.id )
    
    process_data( lines, individual.id, instrument.id, attachment.id, itype.id, device.id, start_time, epoch )
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = ActigraphLoader.new
  if ARGV.length >= 1
    app.load_data( ARGV[0], ARGV[1].delete( '"' ) )
  end  # if
end  # main_method

main_method
