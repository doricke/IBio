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

class SemHrLoader
  
  attr_accessor :heart_beat
  attr_accessor :heart_rate
  
  ###############################################################################
  # Create an input text file object for the named file.
  def initialize
    @heart_beat = {}
    @heart_rate = {}
  end  # method initialize
  
  ###############################################################################
  def local_time( date_time )
    parts = date_time.split( " " )
    date_parts = parts[0].split( "/" )
    time_parts = parts[1].split( ":" )
    sec_parts = time_parts[2].split( "." )
    return Time::local( date_parts[2].to_i, date_parts[0].to_i, date_parts[1].to_i, time_parts[0].to_i, time_parts[1].to_i, sec_parts[0].to_i, sec_parts[1].to_i * 1000 )
  end  # local_time
  
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
  def add_line( measured_at, rate )
    return if rate.nil? || (rate.size < 0 )
    
    min = measured_at.min
    sec = measured_at.sec
    hr = rate.to_i
    return if (hr < 1 )
    
    @heart_beat[ min ] = {} if @heart_beat[ min ].nil?
    @heart_beat[ min ][ sec ] = [] if @heart_beat[ min ][ sec ].nil?
    @heart_beat[ min ][ sec ] << hr
    
    @heart_rate[ min ] = [] if @heart_rate[ min ].nil?
    @heart_rate[ min ] << hr
  end  # add_line
    
  ###############################################################################
  def average_rate( heart_rates )
    # puts "average_rate: #{heart_rates.join('|')}"
    return nil if heart_rates.nil? || (heart_rates.size < 1)
    total = 0.0
    heart_rates.each do |heart_rate|
      total += heart_rate
    end  # do
      
    return total / heart_rates.size.to_f
  end  # average_rate
  
  ###############################################################################
  def get_heart_beats( start_time, end_time )
    # Average the SEM values to heart rates
    heart_beats = []
    
    # puts "get_heart_beats: #{start_min}:#{start_sec} to #{end_min}:#{end_sec}"
    
    for min in start_time.min..end_time.min do
      for sec in start_time.sec..end_time.sec do
        if @heart_beat[ min ].nil? || @heart_beat[ min ][ sec ].nil? || (@heart_beat[ min ][ sec ].size < 1)
          heart_beats << nil
        else
          heart_beats << average_rate( @heart_beat[ min ][ sec ] ).to_i
        end  # if
      end  # for
    end  # do
    
    return heart_beats.join( ',' )
    end  # get_heart_beats
  
  ###############################################################################
  def get_heart_rates( start_time, end_time )
    # Average the SEM values to heart rates
    heart_rates = []
    
    # puts "get_heart_rates: #{start_min} to #{end_min}"
    
    for min in start_time.min..end_time.min do
      if @heart_rate[ min ].nil?
        heart_rates << nil
      else
        heart_rates << average_rate( @heart_rate[ min ] ).to_i
      end  # if
    end  # do
    
    return heart_rates.join( ',' )
  end  # get_heart_rates
    
  ###############################################################################
  def load_heart_rates( date_hour, start_time, end_time, individual_id, instrument_id )
    # puts "load_heart_rates; date_hour: #{date_hour}"
    heart_rates = get_heart_rates( start_time, end_time )
    puts "#{date_hour}: #{heart_rates}"
    
    heart_beats = get_heart_beats( start_time, end_time )
    # puts "..: hb: #{date_hour}: #{heart_beats}"

    load_monitor_data( "heart_rate", individual_id, instrument_id, nil, start_time, end_time, heart_rates, 0, 60 )
    load_monitor_data( "heart rate", individual_id, instrument_id, nil, start_time, end_time, heart_beats, 60, 3600 )
  end  # load_heart_rates
  
  ###############################################################################
  def load_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.where( name: "Equivital SEM" ).take
    instrument = Instrument.create( name: "Equivital SEM", instrument_type: "Health Monitor" ) if instrument.nil?
    
    # itype = Itype.where( name: "Equivital", category: 'attachment' ).take
    # itype = Itype.create( name: "Equivital", category: 'attachment' ) if itype.nil?
    
    sem_file = InputFile.new(filename)
    sem_file.open_file
    line = sem_file.next_line()
    # header = line.split( "," )
    date_hour = nil
    start_time = nil
    end_time = nil
    while ( sem_file.is_end_of_file? == false )
      line = sem_file.next_line()
      if ( sem_file.is_end_of_file? == false )
        tokens = line.split( "," )
        next_time = local_time( tokens[0] )
        
        # puts "next_hour: #{next_hour}"
        if date_hour.nil?
          date_hour = next_time.hour
          start_time = next_time
        end  # if
        
        if ( date_hour != next_time.hour )
          load_heart_rates( date_hour, start_time, end_time, individual.id, instrument.id )
          @heart_beat = {}
          @heart_rate = {}
          date_hour = next_time.hour
          start_time = next_time
        end  # if
        
        add_line( next_time, tokens[1] )
        end_time = next_time
      end  # if
    end  # while
    sem_file.close_file
    
    load_heart_rates( date_hour, start_time, end_time, individual.id, instrument.id ) if ! start_time.nil?
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
  app = SemHrLoader.new
  # app.initialize
  if ARGV.length >= 2
    app.load_data( ARGV[0], ARGV[1].delete( '"' ) )
  end  # if
end  # main_method

main_method
