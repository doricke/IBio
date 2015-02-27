
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

class JawboneLoader
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    jawbone_file = InputFile.new(filename)
    jawbone_file.open_file
    contents = jawbone_file.read_file
    jawbone_file.close_file
    
    individual = Individual.find_by_code_name( "Gimley" )
    
    instrument = Instrument.find_by_name( "Jawbone" )
    
    load_contents( contents, individual.id, instrument.id )
  end #load_Jawbones
  
  
  ###############################################################################
  def load_contents( contents, individual_id, instrument_id )
    puts "#### JawboneLoader called!!!!"
    lines = contents.split( "\n" )
    puts "#### Header: #{lines[0]}, ind: #{individual_id}, inst: #{instrument_id}"
    header = lines[0].split( "," )
    for i in 1...lines.length do
      process_line( header, lines[i], individual_id, instrument_id )
    end  # for
  end  # load_contents
  
  ###############################################################################
  def process_line( header, line, individual_id, instrument_id )
    puts "#### line: #{line}"
    tokens = line.split( "," )
    lookup = {}
    for i in 0...header.size do
      lookup[ header[i] ] = tokens[ i ]
    end  # for
    
    puts "Date: #{lookup['DATE']}"
    year = lookup[ "DATE" ][ 0..3 ]
    month = lookup[ "DATE" ][ 4..5 ]
    day = lookup[ "DATE" ][ 6..7 ]
    sleep_date = Time::local( year.to_i, month.to_i, day.to_i )
    
    if ( lookup[ "s_duration" ].size > 0 )
      sleep_start = sleep_date + lookup[ "s_bedtime" ].to_i
      sleep_end = sleep_date + lookup[ "s_awake_time" ].to_i
      
      sleep = Sleep.where(individual_id: individual_id, instrument_id: instrument_id, start_time: sleep_start).first_or_create.
          update_attributes( :individual_id => individual_id,
          :instrument_id => instrument_id,
          :start_time => sleep_start, 
          :end_time => sleep_end, 
          :secs_asleep => lookup[ "s_duration" ].to_i,
          :light_sleep => lookup[ "s_light" ].to_i,
          :deep_sleep => lookup[ "s_deep" ].to_i,
          :rem_sleep => lookup[ "s_rem" ].to_i,
          :interruptions => lookup[ "s_awakenings" ].to_i,
          :qualifier => lookup[ "s_quality" ] ) 
    end  # if
    
    ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "active time", start_time: sleep_start, end_time: sleep_end).first_or_create.
        update_attributes(:individual_id => individual_id,
        :instrument_id => instrument_id,
        :name => "active time",
        :amount => lookup[ "m_active_time" ].to_f,
        :start_time => sleep_date,
        :end_time => sleep_date)
      
    ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "calories", start_time: sleep_start, end_time: sleep_end).first_or_create.
        update_attributes(:individual_id => individual_id,
        :instrument_id => instrument_id,
        :name => "calories",
        :amount => lookup[ "m_calories" ].to_f,
        :start_time => sleep_date,
        :end_time => sleep_date)
      
    ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "meters", start_time: sleep_start, end_time: sleep_end).first_or_create.
        update_attributes(:individual_id => individual_id,
        :instrument_id => instrument_id,
        :name => "meters",
        :amount => lookup[ "m_distance" ].to_f,
        :start_time => sleep_date,
        :end_time => sleep_date)
      
    ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, name: "steps", start_time: sleep_start, end_time: sleep_end).first_or_create.
        update_attributes(:individual_id => individual_id,
        :instrument_id => instrument_id,
        :name => "steps",
        :amount => lookup[ "m_steps" ].to_f,
        :start_time => sleep_date,
        :end_time => sleep_date)
                               
  end #process line
  
end #class

###############################################################################

def main_method
  app = JawboneLoader.new
  app.load_data( "data/Jawbone_2014.csv" )
end  # main_method

# main_method
