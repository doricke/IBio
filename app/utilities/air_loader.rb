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

class AirLoader
    
  ###############################################################################
  
  attr_accessor :places
  attr_accessor :itypes
  attr_accessor :units
  
  ###############################################################################
  def initialize
    @places = {}
    @itypes = {}
    @units = {}
  end  # initialize
  
  ###############################################################################
  def csv_split( line )
    tokens = []
    i = 0
    token = ""
    in_string = false
    while ( i < line.size ) do
      if ( line[i] == '"' ) && ( token.size == 0 )
        tokens << "" if in_string
        in_string = ! in_string
      else
        if ( line[i] == '"' )
          tokens << token
          token = ""
          in_string = false
        else
          if in_string
            token << line[i]
          else
            if ( line[i] == ',' )
              tokens << token if token.size > 0
              token = ""
            else
              token << line[i]
            end  # if
          end  # if
        end  # if
      end  # if
      i += 1
    end  # while
    
    return tokens
  end  # method csv_split
    
  ###############################################################################
  def find_place( state, county, city, longitude, latitude, site_no )
    # if ( state == "Maine" ) || ( state == "Connecticut" ) || ( state == "Rhode Island" ) || ( state == "Massachusetts" )
    # if ( state == "Massachusetts" )
      if @places[ county ].nil?
        puts "Place: #{state}\t#{county}\t#{city}"
        city_name = city
        city_name = county if ( city_name == "Not in a city" )
        place = Place.where( site_no: site_no ).take
        place = Place.find_by_city_and_state( city_name, state ) if place.nil?
        if place.nil?
          place = Place.create( city: city_name, state: state, longitude: longitude, latitude: latitude, site_no: site_no )
          puts "Created Place: #{city_name}, #{state}, site: #{site_no}"
        else
          puts "Updating site no: #{site_no} for #{place.city}, #{place.state}"
          place.site_no = site_no
          place.save
        end  # if
        @places[ county ] = place
      end  # if
      return @places[ county ]
    # else
    #   return nil
    # end  # if
  end  # find_place
  
  ###############################################################################
  def find_itype( name )
    if @itypes[ name ].nil?
      puts "Itype: #{name}"
      itype = Itype.find_by_name_and_category( name, "Air" )
      itype = Itype.create( name: name, category: "Air" ) if itype.nil?
      @itypes[ name ] = itype
    end  # if
    return @itypes[ name ]
  end  # find_itype
  
  ###############################################################################
  def find_unit( name )
    if @units[ name ].nil?
      puts "Unit: #{name}"
      unit = Unit.find_by_name( name )
      unit = Unit.create( name: name ) if unit.nil?
      @units[ name ] = unit
    end  # if
    return @units[ name ]
  end  # find_unit
  
  ###############################################################################
  def hourly_line( line )
    tokens = csv_split( line )
    
    # Set up Place
    place = find_place( tokens[20], tokens[21], tokens[21], tokens[6].to_f, tokens[5].to_f, tokens[2].to_i )
    return if place.nil?
    
    # Set up Itype
    itype = find_itype( tokens[8] )  # Parameter Name
    
    # Set up Unit
    unit = find_unit( tokens[ 14 ] )  # Units of Measure
    
    # Set up date
    ymd = tokens[9].split( "-" )  # Date Local
    hm = tokens[10].split( ":" )  # Time Local
    day = Time::local( ymd[0].to_i, ymd[1].to_i, ymd[2].to_i, hm[0].to_i, hm[1].to_i )
    air = Air.where( itype_id: itype.id, place_id: place.id, sampled_at: day ).first_or_create.
    update_attributes( itype_id: itype.id, place_id: place.id, sampled_at: day, air_value: tokens[13].to_f, unit_id: unit.id )
  end  # hourly_line
 
  ###############################################################################
  def process_line( line )
    tokens = csv_split( line )
    
    # Set up Place
    place = find_place( tokens[23], tokens[24], tokens[25], tokens[6].to_f, tokens[5].to_f, tokens[2].to_i )
    return if place.nil?
    
    # Set up Itype
    itype = find_itype( tokens[8] )  # Parameter Name
    
    # Set up Unit
    unit = find_unit( tokens[ 12 ] )
    
    # Set up date
    ymd = tokens[11].split( "-" )
    day = Time::local( ymd[0].to_i, ymd[1].to_i, ymd[2].to_i )
    air = Air.where( itype_id: itype.id, place_id: place.id, sampled_at: day ).first_or_create.
        update_attributes( itype_id: itype.id, place_id: place.id, sampled_at: day, air_value: tokens[16].to_f, unit_id: unit.id )
  end  # process_line
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    env_file = InputFile.new(filename)
    env_file.open_file
    
    line = env_file.next_line()  # header line
    header = csv_split( line )
    while ( env_file.is_end_of_file? == false )
      line = env_file.next_line()
      if ( env_file.is_end_of_file? == false )
        if ( header[ 9 ] == "Sample Duration" )
          process_line( line )
        else
          hourly_line( line )
        end  # if
      end  # if
    end  # while
    env_file.close_file
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = AirLoader.new
  if ARGV.length >= 1
    app.load_data( ARGV[0] )
  else
    app.load_data( "test.csv" )
  end  # if
end  # main_method

main_method
