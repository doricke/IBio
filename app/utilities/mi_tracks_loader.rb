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

class MiTracksLoader
  
  ###############################################################################
  def load_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    my_tracks_file = InputFile.new(filename)
    my_tracks_file.open_file
    contents = my_tracks_file.read_file
    my_tracks_file.close_file
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.where( name: "Android Phone" ).take
    
    itype = Itype.where( name: "My Tracks app" ).take
    
    attachment = Attachment.find_by_individual_id_and_name( individual.id, filename )

    if attachment.nil?
      attachment = Attachment.create(individual_id: individual.id, instrument_id: instrument.id,
          itype_id: itype.id, name: filename, created_at: Time::now, file_text: contents, content_type: 'text/csv', is_parsed: true)
    else
      attachment.update_attributes( created_at: Time::now, file_text: contents, is_parsed: true )
      activities = Activity.find_all_by_attachment_id( attachment.id )
      activities.each do |activity|
        locations = Location.find_all_by_activity_id( activity.id )
        locations.each do |location|
          location.destroy
        end  # do
        activity.destroy
      end  # do
    end  # if
    
    my_tracks = MyTracksLoader.new
    my_tracks.load_contents( contents, individual.id, instrument.id, itype.id, attachment.id )
  end #load_data

end #class

###############################################################################

def main_method
  app = MiTracksLoader.new
  app.load_data( ARGV[0].delete( '"' ), ARGV[1].delete( '"' ) )
end  # main_method

###############################################################################

main_method
