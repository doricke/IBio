
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

require 'json'

class MovesLoader

  ###############################################################################
  def load_contents( contents, individual_id, instrument_id, attachment_id )
  
    # puts "##### contents: #{contents}"
  
    json_data = JSON.parse( contents )
    puts "##### json_data: #{json_data}"  
    return
    
    # Check for empty file.
    # puts "skin temp min: |#{json_data['metrics']['skin_temp']['min']}|"
    puts "--> No data" if json_data["metrics"]["skin_temp"]["min"].nil?
    return if json_data["metrics"]["skin_temp"]["min"].nil? 
    
    start_time = Time.at( json_data["starttime"] )
    # puts "##### start_time: #{start_time}"
    
    end_time = Time.at( json_data["starttime"] + 24*60*60 - 1 )
    # puts "##### end_time: #{end_time}"

    skin_temp = json_data["metrics"]["skin_temp"]["values"]  
    # puts "##### skin_temp; # values #{skin_temp.size}"
    load_monitor_data( "skin_temp", individual_id, instrument_id, attachment_id, start_time, end_time, skin_temp )
      
    heart_rate = json_data["metrics"]["heartrate"]["values"]    
    # puts "##### heart_rate; # values #{heart_rate.size}"
    load_monitor_data( "heart_rate", individual_id, instrument_id, attachment_id, start_time, end_time, heart_rate )

    air_temp = json_data["metrics"]["air_temp"]["values"]    
    load_monitor_data( "air_temp", individual_id, instrument_id, attachment_id, start_time, end_time, air_temp )
    
    calories = json_data["metrics"]["calories"]["values"]    
    load_monitor_data( "calories", individual_id, instrument_id, attachment_id, start_time, end_time, calories )
    
    gsr = json_data["metrics"]["gsr"]["values"]    
    load_monitor_data( "gsr", individual_id, instrument_id, attachment_id, start_time, end_time, gsr )
    
    steps = json_data["metrics"]["steps"]["values"]  
    # puts "##### steps; # values #{steps.size}"
    load_monitor_data( "steps", individual_id, instrument_id, attachment_id, start_time, end_time, steps )
    
    interval = json_data["interval"]
    # puts "##### interval: #{interval}"
    
    start_time = json_data["starttime"]
    body_states = json_data["bodystates"]
    # puts "##### body_states: #{body_states}"
    body_states.each do |state|
      start_msec = state[0].to_i
      start_time = Time.at( start_msec )
      end_msec = state[1].to_i
      end_time = Time.at( end_msec )
      puts "#{state[2]} from #{start_time} to #{end_time}"
      
      if ( state[2] == "sleep" )
        Sleep.where(individual_id: individual_id, instrument_id: instrument_id, start_time: start_time, end_time: end_time).first_or_create.
            update_attributes( :individual_id => individual_id,
                :instrument_id => instrument_id,
                :start_time => start_time,
                :end_time => end_time,
                :secs_asleep => (end_msec - start_msec),
                :interruptions => 0,
                :qualifier => "" )
      else
        Itype.where(name: state[2]).first_or_create.update_attributes(name: state[2], :category => "Health Monitor")
        itype = Itype.find_by_name( state[2] )
        ActivitySummary.where(individual_id: individual_id, instrument_id: instrument_id, start_time: start_time, end_time: end_time, name: state[2]).first_or_create.update_attributes(individual_id: individual_id, instrument_id: instrument_id, itype_id: itype.id,
            name: state[2], qualifier: state[2], amount: 0.0, start_time: start_time,
            end_time: end_time, is_public: false)
      end  # if
    end  # do
  end  # load_contents
  
  ###############################################################################
  def load_monitor_data( itype_name, individual_id, instrument_id, attachment_id, start_time, end_time, values )
    itype = Itype.find_by_name( itype_name )
    MonitorDatum.where(individual_id: individual_id, instrument_id: instrument_id, itype_id: itype.id, start_time: start_time, end_time: end_time).first_or_create.
        update_attributes( individual_id: individual_id, instrument_id: instrument_id,
        attachment_id: attachment_id, itype_id: itype.id, start_time: start_time,
        end_time: end_time, points_per_second: 0, points_per_hour: 60, data_vector: values.join( ',' ) )
  end  # load_monitor_data

    
  ###############################################################################

  
end  # class

