require 'input_file.rb'
require 'zip'

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

class ZephyrLoader

  attr_accessor :breathing_rate
  attr_accessor :heart_beats
  attr_accessor :heart_rate
  attr_accessor :skin_temp
  
  ###############################################################################
  # Create an input text file object for the named file.
  def initialize
    @breathing_rate = {}
    @heart_beats = []
    @heart_rate = {}
    @skin_temp = {}
  end  # method initialize
  
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
  def local_time( date_time )
    parts = date_time.split( " " )
    date_parts = parts[0].split( "/" )
    time_parts = parts[1].split( ":" )
    sec_parts = time_parts[2].split( "." )
    
    # year = date_parts[2].to_i
    # mon = date_parts[1].to_i
    # day = date_parts[0].to_i
    # hour = time_parts[0].to_i
    # min = time_parts[1].to_i
    # sec = sec_parts[0].to_i
    # usec = sec_parts[1].to_i * 1000
    
    # puts "Date: #{date_time}"
    # puts "Time: #{year} #{mon} #{day} #{hour} #{min} #{sec} #{usec}"
    
    return Time::local( date_parts[2].to_i, date_parts[1].to_i, date_parts[0].to_i, time_parts[0].to_i, time_parts[1].to_i, sec_parts[0].to_i, sec_parts[1].to_i * 1000 )
  end  # local_time
  
  ###############################################################################
  def add_line( header, line )
    tokens = line.split( "," )
  
    measured_at = local_time( tokens[0] )
    time_str = get_time_str( measured_at )

    @heart_rate[ time_str ] = [] if @heart_rate[ time_str ].nil?
    @breathing_rate[ time_str ] = [] if @breathing_rate[ time_str ].nil?
    
    heart_rate = tokens[1].to_i
    @heart_rate[ time_str ] << heart_rate
    @heart_beats << heart_rate
    br = tokens[2].to_f
    br = 0 if br > 500.0
    @breathing_rate[ time_str ] << br
    # @skin_temp << tokens[3].to_f
  end  # add_line
  
  ###############################################################################
  def average_rate( heart_rates )
    return nil if heart_rates.nil? || (heart_rates.size < 1)
    total = 0.0
    heart_rates.each do |heart_rate|
      total += heart_rate
    end  # do
    
    return total / heart_rates.size.to_f
  end  # average_rate
  
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
  def get_heart_rates
    # Average the SEM values to heart rates
    heart_rates = []
    
    loop_time = @start_time
    while ( loop_time < end_time ) do
      heart_rates << average_rate( @heart_rates[ "#{loop_time.day}#{loop_time.hour}#{loop_time.min}" ] ).to_i
      loop_time += 60
    end  # do
    
    return heart_rates.join( ',' )
    end  # get_heart_rates
    
  ###############################################################################
  def load_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.where( name: "Zephyr BioHarness" ).take
    instrument = Instrument.create( name: "Zephyr BioHarness", instrument_type: "Health Monitor" ) if instrument.nil?
    
    itype = Itype.where( name: "Zephyr", category: 'attachment' ).take
    itype = Itype.create( name: "Zephyr", category: 'attachment' ) if itype.nil?
    
    sem_file = InputFile.new(filename)
    sem_file.open_file
    contents = sem_file.read_file
    sem_file.close_file
    
    attachment = Attachment.find_by_individual_id_and_name( individual.id, filename )
    
    if attachment.nil?
      attachment = Attachment.create(individual_id: individual.id, instrument_id: instrument.id,
          itype_id: itype.id, name: filename, created_at: Time::now, file_text: contents, content_type: 'text/csv', is_parsed: true)
    else
      attachment.update_attributes( created_at: Time::now, file_text: contents, is_parsed: true )
    end  # if

    lines = contents.split( "\n" )
    header = lines[0]
    for i in 1...lines.size do
      add_line( header, lines[i] )
    end  # for

    line1 = lines[1].split( "," )
    @start_time = local_time( line1[ 0 ] )
    line_n = lines[ lines.size-1 ].split( "," )
    @end_time = local_time( line_n[ 0 ] )
    puts "Start time: #{@start_time} to #{@end_time}"

    ave_heart_rates = average_rates( @start_time, @end_time, heart_rate, 60 )
    puts "Last Day: #{@start_time} to #{@end_time}: #{ave_heart_rates}"
    load_monitor_data( "heart_rate", individual.id, instrument.id, attachment.id, @start_time, @end_time, ave_heart_rates, 0, 60 ) if ave_heart_rates.size > 0

    puts "Heart beats: #{@heart_beats}"
    load_monitor_data( "heart rate", individual.id, instrument.id, attachment.id, @start_time, @end_time, @heart_beats, 60, 3600 )
    # load_monitor_data( "breathing rate", individual.id, instrument.id, attachment.id, @start_time, @end_time, @breathing_rate, 60, 3600 )
  end # load_data
  
  ###############################################################################
  def load_monitor_data( itype_name, individual_id, instrument_id, attachment_id, start_time, end_time, values, points_second, points_hour )
    itype = Itype.where( name: itype_name ).take
    itype = Itype.create( name: itype_name, category: "Health Monitor" ) if itype.nil?
    
    MonitorDatum.where(individual_id: individual_id, instrument_id: instrument_id, itype_id: itype.id, start_time: start_time, end_time: end_time).first_or_create.
    update_attributes( individual_id: individual_id, instrument_id: instrument_id,
                      attachment_id: attachment_id, itype_id: itype.id, start_time: start_time,
                      end_time: end_time, points_per_second: points_second, points_per_hour: points_hour, data_vector: values )
  end  # load_monitor_data
  
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = ZephyrLoader.new
  # app.initialize
  if ARGV.length >= 2
    app.load_data( ARGV[0], ARGV[1].delete( '"' ) )
  end  # if
end  # main_method

main_method
