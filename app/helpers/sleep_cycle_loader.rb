
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

class SleepCycleLoader
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    sleep_cycle_file = InputFile.new(filename)
    sleep_cycle_file.open_file
    contents = sleep_cycle_file.read_file
    sleep_cycle_file.close_file
    
    individual = Individual.find_by_code_name( "Gimley" )
    
    instrument = Instrument.find_by_name( "IPhone" )
    
    load_contents( contents, individual.id, instrument.id )
  end #load_data
  
  ###############################################################################
  def load_contents( contents, individual_id, instrument_id, itype_id, attachment_id )
    lines = contents.split( "\n" )
    
    # Load Sleep data
    header = lines[0].split(';')
    process_sleep( header, lines[1..-1], individual_id, instrument_id )
  end  # load_contents
  
  ###############################################################################
  def time_at(entry)
    parts = entry.split(' ')
    # 2012-12-02
    tokens = parts[0].split('-')
    year = tokens[0].to_i
    month = tokens[1].to_i
    day = tokens[2].to_i
    
    # 21:57:08
    tokens = parts[1].split(':')
    hour = tokens[0].to_i
    min = tokens[1].to_i
    sec = tokens[2].to_i
    sleep_time = Time::local( year, month, day, hour, min, sec )
    return sleep_time
  end  # time_at
  
  ###############################################################################
  def process_sleep( header, lines, individual_id, instrument_id )
    lines.each do |line|
      lookup = {}
      tokens = line.delete( '"' ).split( ";" )
        
      to_sleep = time_at( tokens[0] )
      from_sleep = time_at( tokens[1] )
      
      secs_asleep = from_sleep.to_i - to_sleep.to_i
      puts "#### seconds asleep: #{secs_asleep}"
      
      note_id = nil
      if ( ! tokens[5].nil? ) && ( tokens[5].size > 0 )
        note = Note.find_by_comment( tokens[5] )
        note = Note.create(comment: tokens[5]) if note.nil?
        note_id = note.id
      end  # if
    
      wake_up = ""
      wake_up = tokens[4][1..-1] if (! tokens[4].nil?) && ( tokens[4].size > 0 )
      if secs_asleep > 0
        sleep = Sleep.where(individual_id: individual_id, instrument_id: instrument_id, start_time: to_sleep).first_or_create.
            update_attributes( :individual_id => individual_id,
            :instrument_id => instrument_id,
            :note_id => note_id,
            :start_time => to_sleep,
            :end_time => from_sleep,
            :secs_asleep => secs_asleep,
            :qualifier => tokens[2],
            :wake_up => wake_up )
      end # if
    
    end  # do
  end  # process_sleep
  
end #class

###############################################################################

def main_method
  app = SleepCycleLoader.new
  app.load_data( "data/2013.csv" )
end  # main_method

# main_method
