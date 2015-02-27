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

class EmpaticaZipLoader
  
  ###############################################################################
  def load_zip_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.where( name: "Empatica E3" ).take
    instrument = Instrument.create( name: "Empatica E3", instrument_type: "Health Monitor" ) if instrument.nil?
    
    itype = Itype.where( name: "Empatica", category: 'attachment' ).take
    itype = Itype.create( name: "Empatica", category: 'attachment' ) if itype.nil?
    
    ibi_loader = EmpaticaLoader.new
    Zip::File.open(filename) do |zip_file|
      zip_file.each do |entry|
        name = "#{filename}_#{entry.name}"
        puts "--> #{name}"
        if (entry.name != "info.txt")
          contents = entry.get_input_stream.read
          attachment = Attachment.where( individual_id: individual.id, name: name ).take
          if attachment.nil?
            attachment = Attachment.create(individual_id: individual.id, instrument_id: instrument.id, itype_id: itype.id, name: name, content_type: "text/csv", file_text: contents, is_parsed: true, created_at: Time::now)
          else
            attachment.update_attributes(individual_id: individual.id, instrument_id: instrument.id, itype_id: itype.id, name: name,   content_type: "text/csv", file_text: contents, is_parsed: true, created_at: Time::now)
          end  # if
    
          ibi_loader.load_contents( entry.name, contents, individual.id, instrument.id, attachment.id )
        end  # if
      end  # do
    end  # do
  end # load_zip_data
  
  ###############################################################################
  def load_data( filename, data_entry_id )
    puts "Loading file: #{filename}"
    
    empatica_file = InputFile.new(filename)
    empatica_file.open_file
    contents = empatica_file.read_file
    empatica_file.close_file
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.where( name: "Empatica E3" ).take
    instrument = Instrument.create( name: "Empatica E3", instrument_type: "Health Monitor" ) if instrument.nil?
    
    itype = Itype.where( name: "Empatica", category: 'attachment' ).take
    itype = Itype.create( name: "Empatica", category: 'attachment' ) if itype.nil?
    
    attachment = Attachment.where( individual_id: individual.id, name: filename ).take
    if attachment.nil?
      attachment = Attachment.create(individual_id: individual.id, instrument_id: instrument.id, itype_id: itype.id, name: filename, content_type: "text/plain", file_text: contents, is_parsed: true, created_at: Time::now)
    else
      attachment.update_attributes(individual_id: individual.id, instrument_id: instrument.id, itype_id: itype.id, name: filename, content_type: "text/plain", file_text: contents, is_parsed: true, created_at: Time::now)
    end  # if
    
    ibi_loader = EmpaticaLoader.new
    ibi_loader.load_contents( contents, individual.id, instrument.id, attachment.id )
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = EmpaticaZipLoader.new
  if ARGV.length >= 2
    app.load_zip_data( ARGV[0], ARGV[1].delete( '"' ) )
  end  # if
end  # main_method

main_method
