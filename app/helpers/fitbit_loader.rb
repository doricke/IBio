
################################################################################
# Copyright (C) 2015  Darrell O. Ricke, PhD
# Author::    	Darrell O. Ricke, Ph.D.  (mailto: Darrell.Ricke@ll.mit.edu)
# Copyright:: 	Copyright (c) 2014 MIT Lincoln Laboratory
# License::   	GNU GPL license  (http://www.gnu.org/licenses/gpl.html)
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

require 'input_file.rb'

class FitbitLoader
  
  ###############################################################################
  def load_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    fitbit_file = InputFile.new(filename)
    fitbit_file.open_file
    contents = fitbit_file.read_file
    fitbit_file.close_file
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.find_by_name( "Fitbit" )
    
    load_contents( contents, individual.id, instrument.id )
  end #load_data
  
  
  ###############################################################################
  def load_contents( contents, individual_id, instrument_id )
    lines = contents.split( "\n" )
    body_i = 0
    activity_i = 0
    sleep_i = 0
    for i in 0...lines.length do
      body_i = i if lines[i] == "Body"
      activity_i = i if lines[i] == "Activities"
      sleep_i = i if lines[i] == "Sleep"
    end  # for
  
    # puts "body_i: #{body_i}, activity_i: #{activity_i}, sleep_i: #{sleep_i}"
    
    # Load Activity data
    header = lines[ activity_i+1 ].split( ',' )
    process_activity( header, lines[activity_i+2...(sleep_i-1)], individual_id, instrument_id )
    
    # Load Sleep data
    header = lines[ sleep_i+1 ].split( ',' )
    process_sleep( header, lines[sleep_i+2..-1], individual_id, instrument_id )
  end  # load_contents
    
  ###############################################################################
  def process_activity( header, lines, individual_id, instrument_id )
    lines.each do |line|
      lookup = {}
      tokens = line.split( "\"," )
      for i in 0...header.size do
        lookup[ header[i] ] = tokens[ i ].delete( "," ).delete( '"' )
      end  # for
      
    if (lookup[ "Minutes Sedentary" ] != "1440" )
      parts = tokens[0].delete( '"' ).split( '-' )
      year = parts[0].to_i
      month = parts[1].to_i
      day = parts[2].to_i
      # puts "Date: #{tokens[0]}, year: #{year}, month: #{month}, day: #{day}"
      active_date = Time::local( year, month, day )
      
      calories = lookup[ "Calories Burned" ].to_f
      ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "calories", start_time: active_date).first_or_create.
          update_attributes(:individual_id => individual_id,
          :instrument_id => instrument_id,
          :name => "calories",
          :amount => calories,
          :start_time => active_date,
          :end_time => active_date) if calories > 0.0
        
      steps = lookup[ "Steps" ].to_f
      ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "steps", start_time: active_date).first_or_create.
          update_attributes(:individual_id => individual_id,
          :instrument_id => instrument_id,
          :name => "steps",
          :amount => steps,
          :start_time => active_date,
          :end_time => active_date) if steps > 0.0
        
      distance = lookup[ "Distance" ].to_f
      ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "distance", start_time: active_date).first_or_create.
          update_attributes(:individual_id => individual_id,
          :instrument_id => instrument_id,
          :name => "distance",
          :amount => distance,
          :start_time => active_date,
          :end_time => active_date) if distance > 0.0
        
      light_active = lookup[ "Minutes Lightly Active" ].to_f
      ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "light active", start_time: active_date).first_or_create.
          update_attributes(:individual_id => individual_id,
          :instrument_id => instrument_id,
          :name => "light active",
          :amount => light_active,
          :start_time => active_date,
          :end_time => active_date) if light_active > 0.0
        
      fairly_active = lookup[ "Minutes Fairly Active" ].to_f
      ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "fairly active", start_time: active_date).first_or_create.
          update_attributes(:individual_id => individual_id,
          :instrument_id => instrument_id,
          :name => "fairly active",
          :amount => fairly_active,
          :start_time => active_date,
          :end_time => active_date) if fairly_active > 0.0
        
      very_active = lookup[ "Minutes Very Active" ].to_f
      ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "vert actuve", start_time: active_date).first_or_create.
          update_attributes(:individual_id => individual_id,
          :instrument_id => instrument_id,
          :name => "very active",
          :amount => very_active,
          :start_time => active_date,
          :end_time => active_date) if very_active > 0.0
     end  # if
    end # do
  end  # process_activity
    
  ###############################################################################
  def process_sleep( header, lines, individual_id, instrument_id )
    lines.each do |line|
     if (line.length > 0)
      # puts ">>>> sleep line: #{line}"
      lookup = {}
      tokens = line.split( "\"," )
      for i in 0...header.size do
        lookup[ header[i] ] = tokens[ i ].delete( '"' ).delete( "," ) if ! tokens[ i ].nil?
      end  # for
        
      parts = tokens[0].delete( '"' ).split( '-' )
      year = parts[0].to_i
      month = parts[1].to_i
      day = parts[2].to_i
      sleep_date = Time::local( year, month, day )
    
      min_sleep = lookup[ "Minutes Asleep" ].to_i
      # puts "##### Date: #{tokens[0]}, sleep min #{min_sleep}, tokens.1: #{tokens[1]}"
      if min_sleep > 0
        sleep = Sleep.where(individual_id: individual_id, instrument_id: instrument_id, start_time: sleep_date).first_or_create.
            update_attributes( :individual_id => individual_id,
            :instrument_id => instrument_id,
            :start_time => sleep_date,
            :end_time => sleep_date,
            :secs_asleep => min_sleep * 60,
            :interruptions => lookup[ "Number of Awakenings" ].to_i )
      end # if
     end  # if
    end  # do
  end  # process_sleep
  
end #class

###############################################################################

def main_method
  app = FitbitLoader.new
  app.load_data( ARGV[0].delete( '"' ), ARGV[1].delete( '"' ) )
end  # main_method

# main_method
