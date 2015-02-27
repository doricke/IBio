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
require 'json'

class BasisLoader
  
  ###############################################################################
  def load_sleep_record( json_data, individual_id, instrument_id, attachment_id )
    # puts "load_sleep_record called"

    tokens = json_data["content"]["date"].split("-")
    sleep_date = Time::local( tokens[0].to_i, tokens[1].to_i, tokens[2].to_i )
    Sleep.where( individual_id: individual_id, instrument_id: instrument_id, start_time: sleep_date, end_time: sleep_date ).first_or_create.
        update_attributes( :individual_id => individual_id,
            :instrument_id => instrument_id,
            :start_time => sleep_date,
            :end_time => sleep_date,
            :secs_asleep => json_data["content"]["minutes"].to_i * 60,
            :light_sleep => json_data["content"]["light_minutes"].to_i * 60,
            :deep_sleep => json_data["content"]["deep_minutes"].to_i * 60,
            :rem_sleep => json_data["content"]["rem_minutes"].to_i * 60,
            :interruptions => json_data["content"]["interruptions"].to_i,
            :qualifier => json_data["content"]["quality"] )
  
    # puts "New sleep record: #{sleep_date}"
  end  # load_sleep_record
  
  ###############################################################################
  def load_activities_record( json_data, individual_id, instrument_id, attachment_id )
    # puts "load_activites_record called"
    
    activities = json_data["content"]["activities"]
    activities.each do |activity|
      activity_type = activity["type"]
      Itype.where( name: activity_type).first_or_create.update_attributes( name: activity_type, :category => "Health Monitor" )
      itype = Itype.find_by_name( activity_type )
      activity_amount = 0.0
      if ( activity_type == "walk" ) || ( activity_type == "run" )
        activity_amount = activity["steps"].to_f
      end  # if
      activity_amount = activity["actual_seconds"].to_f / 60.0 if ( activity_type == "bike" )
      # puts "New activity: #{activity_type} amount: #{activity_amount}"
      start_time = Time.at( activity["start_time"]["timestamp"].to_i )
      end_time = Time.at( activity["end_time"]["timestamp"].to_i )
      ActivitySummary.where( individual_id: individual_id, instrument_id: instrument_id, start_time: start_time, end_time: end_time, name: activity_type ).first_or_create.
          update_attributes( :individual_id => individual_id,
             :instrument_id => instrument_id,
             :itype_id => itype.id,
             :name => activity_type,
             :qualifier => activity_type,
             :amount => activity_amount,
             :calories => activity["calories"].to_f,
             :start_time => start_time,
             :end_time => end_time,
             :is_public => false )
    end  # do
    
  end  # load_activities_record
  
  ###############################################################################
  def load_contents( contents, individual_id, instrument_id, attachment_id )
    
    json_data = JSON.parse( contents )
    # puts "##### json_data: #{json_data}"
    # puts "BasisLoader.load_contents called"
  
    # puts "##### contents: #{contents}"
    if ! json_data["content"].nil?
      if ! json_data["content"]["light_minutes"].nil?
        load_sleep_record( json_data, individual_id, instrument_id, attachment_id )
        return
      end  # if
    
      if ! json_data["content"]["activities"].nil?
        load_activities_record( json_data, individual_id, instrument_id, attachment_id )
        return
      end  # if
    end  # if
    
    # Check for empty file.
    # puts "skin temp min: |#{json_data['metrics']['skin_temp']['min']}|"
    puts "--> No data" if json_data["metrics"]["skin_temp"]["values"].nil?
    return if json_data["metrics"]["skin_temp"]["values"].nil?
    
    start_time = Time.at( json_data["starttime"] )
    # puts "##### start_time: #{start_time}"
    
    end_time = Time.at( json_data["starttime"] + 24*60*60 - 1 )
    # puts "##### end_time: #{end_time}"

    skin_temp = json_data["metrics"]["skin_temp"]["values"].join( ',' )
    # puts "##### skin_temp; # values #{skin_temp.size}"
    load_monitor_data( "skin_temp", individual_id, instrument_id, attachment_id, start_time, end_time, skin_temp )
      
    heart_rate = json_data["metrics"]["heartrate"]["values"].join( ',' )
    # puts "##### heart_rate; # values #{heart_rate.size}"
    load_monitor_data( "heart_rate", individual_id, instrument_id, attachment_id, start_time, end_time, heart_rate )

    if ! json_data["metrics"]["air_temp"].nil?
      air_temp = json_data["metrics"]["air_temp"]["values"].join( ',' )
      load_monitor_data( "air_temp", individual_id, instrument_id, attachment_id, start_time, end_time, air_temp )
    end  # if
    
    calories = json_data["metrics"]["calories"]["values"].join( ',' )
    load_monitor_data( "calories", individual_id, instrument_id, attachment_id, start_time, end_time, calories )
    
    gsr = json_data["metrics"]["gsr"]["values"].join( ',' )
    load_monitor_data( "gsr", individual_id, instrument_id, attachment_id, start_time, end_time, gsr )
    
    steps = json_data["metrics"]["steps"]["values"].join( ',' )
    # puts "##### steps; # values #{steps.size}"
    load_monitor_data( "steps", individual_id, instrument_id, attachment_id, start_time, end_time, steps )

    load_body_states( json_data, individual_id, instrument_id, attachment_id ) if ! json_data["bodystates"].nil?
  end  # load_contents
  
  ###############################################################################
  def load_body_states( json_data, individual_id, instrument_id, attachment_id )
    
    # interval = json_data["interval"]
    # puts "##### interval: #{interval}"
    
    start_time = json_data["starttime"]
    body_states = json_data["bodystates"]
    # puts "##### body_states: #{body_states}"
    body_states.each do |state|
      start_msec = state[0].to_i
      start_time = Time.at( start_msec )
      end_msec = state[1].to_i
      end_time = Time.at( end_msec )
      # puts "#{state[2]} from #{start_time} to #{end_time}"
      
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
    
  end  # load_body_states
  
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
  def loadFile( filename, individual_id, instrument_id, itype_id )
    basis_file = InputFile.new(filename)
    basis_file.open_file
    contents = basis_file.read_file
    basis_file.close_file
    
    attachment = Attachment.where( individual_id: individual_id, name: filename ).take
    if attachment.nil?
      attachment = Attachment.create(individual_id: individual_id, instrument_id: instrument_id, itype_id: itype_id, name: filename, content_type: "application/json", file_text: contents, is_parsed: true, created_at: Time::now)
    else
      attachment.update_attributes(individual_id: individual_id, instrument_id: instrument_id, itype_id: itype_id, name: filename, content_type: "application/json", file_text: contents, is_parsed: true, created_at: Time::now)
    end  # if
    
    return contents, attachment.id
  end  # loadFile
  
  ###############################################################################
  def basisSync(individual_id, email_name, pw, date_start, date_end, device)
  
    individual = Individual.where( individual_id ).take
    data_entry_id = individual.data_entry_id
    instrument = Instrument.where( name: "Basis watch" ).take
    if (device == "Peak")
      instrument = Instrument.where( name: "Basis Peak").take
      instrument = Instrument.create( name: "Basis Peak", instrument_type: "Health Monitor") if instrument.nil?
    end  # if
    
    itype = Itype.where( name: "Basis" ).take
  
    Thread.new do
      # Do the work.
      day = date_start
      begin
        puts "Basis Loader date: #{day}"
        the_date = "#{day.year}-#{day.mon}-#{day.day}"
        system( "java -jar BasisDay.jar #{email_name} #{pw} #{data_entry_id} #{the_date}" )
        names = ["#{data_entry_id}_activity-#{the_date}.json",
                 "#{data_entry_id}_sleep-#{the_date}.json",
                 "#{data_entry_id}_data-#{the_date}.json",
                 "#{data_entry_id}_activities-#{the_date}.json"]
        names.each do |filename|
          contents, attachment_id = loadFile( filename, individual_id, instrument.id, itype.id )
          load_contents( contents, individual_id, instrument.id, attachment_id )
          # system( "rm #{filename}" )
        end  # do
        day += 1
      end while (day <= date_end)
        
      ActiveRecord::Base.connection.close     # Close the database connection
      puts "Basis Loader Thread done"
    end  # do
  end  # basisSync
    
  ###############################################################################

  
end #class

