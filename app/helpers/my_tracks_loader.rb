
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

class MyTracksLoader
  
  ###############################################################################
  def load_contents( contents, individual_id, instrument_id, itype_id, attachment_id )
    lines = contents.split( "\n" )
    
    tokens = lines[1].split( ',' )
    activity = Activity.create(individual_id: individual_id, itype_id: itype_id, attachment_id: attachment_id, activity_name: tokens[0] )
    
    # Load Activity data
    process_activity( lines[4...lines.size], individual_id, instrument_id, itype_id, activity )
  end  # load_contents
    
  ###############################################################################
  def process_activity( lines, individual_id, instrument_id, itype_id, activity )
    tokens = lines[0].split( "," )
    last_time = get_time( tokens[8].delete( '"' ) )
    activity.start_time = last_time
  
    lines.each do |line|
      if (! line.include?( "Time" ) )
        # puts "line: #{line}"
        tokens = line.split( "\"," )
        last_time = get_time( tokens[8].delete( '"' ) ) if (! tokens[8].nil?) && (tokens[8].size > 0)
        latitude = longitude = altitude = bearing = speed = nil
        latitude = tokens[2].delete( '"' ).to_f if tokens[2]
        longitude = tokens[3].delete( '"' ).to_f if tokens[3]
        altitude = tokens[4].delete( '"' ).to_i if tokens[4]
        bearing = tokens[5].delete( '"' ).to_i if tokens[5]
        speed = tokens[7].delete( '"' ).to_f if tokens[7]
        Location.create(individual_id: individual_id, activity_id: activity.id, latitude: latitude, longitude: longitude, altitude: altitude, bearing: bearing, speed: speed, created_at: last_time)
      end  # if
    end # do
    
    activity.end_time = last_time
    activity.save
  end  # process_activity
    
  ###############################################################################
  def get_time( time_str )
    # puts "-- time: #{time_str}"
    date_parts = time_str[0..9].split( '-' )
    time_parts = time_str[11..-1].split( ':' )
    return Time::utc( date_parts[0].to_i, date_parts[1].to_i, date_parts[2].to_i, time_parts[0].to_i, time_parts[1].to_i, time_parts[2][0..1].to_i, time_parts[2][3..5].to_i)
  end  # get_time

###############################################################################

end #class


