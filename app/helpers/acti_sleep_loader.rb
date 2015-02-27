
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

class ActiSleepLoader
  
  ###############################################################################
  def load_contents( contents, individual_id, instrument_id, itype_id, attachment_id )
    # puts "#### ActiSleepLoader called!!!!"
    lines = contents.split( "\n" )
    header = lines[5].split( "," )
    for i in 6...lines.length do
      process_line( header, lines[i], individual_id, instrument_id )
    end  # for
  end  # load_contents
  
  ###############################################################################
  def process_line( header, line, individual_id, instrument_id )
    # puts "#### line: #{line}"
    tokens = line.split( "," )
    lookup = {}
    for i in 0...header.size do
      lookup[ header[i] ] = tokens[ i ]
    end  # for
    
    # puts "Date: #{lookup['In Bed Date']}"
    parts = lookup[ "In Bed Date" ].split("/")
    year = parts[2]
    month = parts[0]
    day = parts[1]
    parts = lookup[ "In Bed Time"].split(" ")
    tokens = parts[0].split(":")
    hour = tokens[0].to_i
    hour = hour + 12 if parts[1] == "PM"
    min = tokens[1]
    sleep_start = Time::local( year.to_i, month.to_i, day.to_i, hour, min.to_i )
    
    # Out Bed Time
    parts = lookup[ "Out Bed Date" ].split("/")
    year = parts[2]
    month = parts[0]
    day = parts[1]
    parts = lookup[ "Out Bed Time" ].split(" ")
    tokens = parts[0].split(":")
    hour = tokens[0].to_i
    hour = hour + 12 if parts[1] == "PM"
    min = tokens[1]
    sleep_end = Time::local( year.to_i, month.to_i, day.to_i, hour, min.to_i )
    
    if ( lookup[ "Total Sleep Time (TST)" ].size > 0 )
      
      sleep = Sleep.where(individual_id: individual_id, instrument_id: instrument_id, start_time: sleep_start).first_or_create.
          update_attributes( :individual_id => individual_id,
          :instrument_id => instrument_id,
          :start_time => sleep_start, 
          :end_time => sleep_end, 
          :secs_asleep => lookup[ "Total Sleep Time (TST)" ].to_i * 60,
          :interruptions => lookup[ "Number of Awakenings" ].to_i,
          :qualifier => lookup[ "Efficiency" ] )
    end  # if
                               
  end # process line
  
end # class

###############################################################################

