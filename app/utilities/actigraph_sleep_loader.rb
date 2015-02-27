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

class ActigraphSleepLoader
  
  ###############################################################################
  def average_rate( heart_rates )
    return nil if heart_rates.nil? || (heart_rates.size < 1)
    total = 0.0
    heart_rates.each do |heart_rate|
      total += heart_rate.to_f
    end  # do
    
    return total / heart_rates.size.to_f
  end  # average_rate
  
  ###############################################################################
  def to_s( i )
    if ( i < 10 )
      return "0#{i}"
    end  # if
    return "#{i}"
  end  # to_s
  
  ###############################################################################
  def get_time_str( time_var )
    return "#{to_s(time_var.day)}#{to_s(time_var.hour)}#{to_s(time_var.min)}"
  end  # get_time_str
  
  ###############################################################################
  def average_rates( start_time, end_time, heart_rates, epoch )
    # puts "heart_rates:"
    # heart_rates.each do |time, values|
    #   puts "..>#{time}: #{values}"
    # end  # do
  
    ave_rates = []
    loop_time = start_time
    while ( loop_time < end_time ) do
      time_str = get_time_str( loop_time )
      # puts "#{time_str}: #{heart_rates[time_str].join('|')}"
      ave_rates << average_rate( heart_rates[ time_str ] ).to_i
      loop_time = loop_time + epoch
    end  # do
    
    return ave_rates.join( "," )
    end  # average_rates
  
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
    
    # puts "#{header[4]}"
    tokens = header[4].split( " " )
    parts = tokens[3].split( ":" )
    # puts "parts: #{parts.join('|')}"
    epoch = parts[2].to_i
    epoch = parts[1].to_i * 60 if (epoch < 1)
    
    puts "Epoch: #{epoch}"
    return start_time, device, epoch
  end  # process_header
  
  ###############################################################################
  def split_line( line, is_dat_file )
    return line.split( "," ) if ! is_dat_file
  
    tokens = []
    for i in 0...10 do
      tokens << line[ (i*8)...(i*8+8) ].delete( ' ' )
    end  # for
    
    # puts "#{tokens.join('|')}"
    return tokens
  end  # split_line
  
  ###############################################################################
  def process_data( lines, individual_id, instrument_id, attachment_id, itype_id, device_id, start_time, epoch, is_dat_file )
    index_start = 10
    index_start = 11 if ( lines[ index_start ][ 0..3 ] == "Axis" )
    time_start = start_time
  
    # Find the start of the heart rate.
    tokens = split_line( lines[ index_start ], is_dat_file )
    heart_rate = "0"
    heart_rate = tokens[5] if ! tokens[4].nil?
    while ( index_start < lines.size ) && ( heart_rate == "0" )
      tokens = split_line( lines[ index_start ], is_dat_file )
      heart_rate = "0"
      heart_rate = tokens[4] if ! tokens[4].nil?
      index_start += 1
      time_start += epoch
    end  # while
  
    time_end = time_start
    heart_rates = {}
    if heart_rate != "0"
      time_str = get_time_str( time_start )
      heart_rates[ time_str ] = [] if heart_rates[ time_str ].nil?
      heart_rates[ time_str ] << heart_rate
    end  # if
    
    while ( index_start < lines.size )
      time_next = time_end + epoch
      if ( time_end.day != time_next.day )
        
        ave_heart_rates = average_rates( time_start, time_end, heart_rates, epoch )
        puts "New Day: #{time_start} to #{time_end}: #{ave_heart_rates}"
        load_monitor_data( "heart_rate", individual_id, instrument_id, attachment_id, time_start, time_end, ave_heart_rates) if ave_heart_rates.size > 0
        time_start = time_next
        heart_rates = {}
      end  # if

      tokens = split_line( lines[ index_start ], is_dat_file )
      heart_rate = tokens[4].to_f
      time_str = get_time_str( time_next )
      heart_rates[ time_str ] = [] if heart_rates[ time_str ].nil?
      heart_rates[ time_str ] << heart_rate

      time_end = time_next
      index_start += 1
    end  # while

    ave_heart_rates = average_rates( time_start, time_end, heart_rates, epoch )
    puts "Last Day: #{time_start} to #{time_end}: #{ave_heart_rates}"
    load_monitor_data( "heart_rate", individual_id, instrument_id, attachment_id, time_start, time_end, ave_heart_rates) if ave_heart_rates.size > 0
   
  end  # process_data
  
  ###############################################################################
  def load_data( filename, data_entry_id, instrument_name )
    puts "Loading file: #{filename}"
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.where( name: instrument_name ).take
    instrument = Instrument.create( name: instrument_name, instrument_type: "Accelerometer" ) if instrument.nil?
    
    itype = Itype.where( name: "Actigraph" ).take
    itype = Itype.create( name: "Actigraph", category: "Health Monitor" ) if itype.nil?
    
    actigraph_file = InputFile.new( filename )
    actigraph_file.open_file
    contents = actigraph_file.read_file.delete( "\r" )
    actigraph_file.close_file
    filename_parts = filename.split( '/' )
    attachment = Attachment.where( name: filename_parts[-1] ).take
    attachment = Attachment.create( individual_id: individual.id, instrument_id: instrument.id, itype_id: itype.id, name: filename_parts[-1], content_type: "text/csv", file_text: contents, is_parsed: true ) if attachment.nil?

    lines = contents.split( "\n" )
    start_time, device, epoch = process_header( lines[0..20], instrument.id, individual.id )
    
    is_dat_file = filename.include?( ".dat" )
    process_data( lines, individual.id, instrument.id, attachment.id, itype.id, device.id, start_time, epoch, is_dat_file )
  end # load_data
  
  ###############################################################################
  def load_monitor_data( itype_name, individual_id, instrument_id, attachment_id, start_time, end_time, values )
    return if (values[0..4] == ",,,,," )
    itype = Itype.find_by_name( itype_name )
    MonitorDatum.where(individual_id: individual_id, instrument_id: instrument_id, itype_id: itype.id, start_time: start_time, end_time: end_time).first_or_create.
    update_attributes( individual_id: individual_id, instrument_id: instrument_id,
                      attachment_id: attachment_id, itype_id: itype.id, start_time: start_time,
                      end_time: end_time, points_per_second: 0, points_per_hour: 60, data_vector: values )
  end  # load_monitor_data
  
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = ActigraphSleepLoader.new
  if ARGV.length >= 1
    app.load_data( ARGV[0], ARGV[1].delete( '"' ), ARGV[2] )
  end  # if
end  # main_method

main_method
