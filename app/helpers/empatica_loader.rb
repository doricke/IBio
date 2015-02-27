
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

class EmpaticaLoader
  
  ###############################################################################
  def average_rate( heart_rates )
    return nil if heart_rates.nil? || (heart_rates.size < 1)
    total = 0.0
    heart_rates.each do |heart_rate|
      total += heart_rate
    end  # do
    
    return total / heart_rates.size.to_f
  end  # average_rate
  
  ###############################################################################
  def ibi_to_heart_rate( base_time, start_time, end_time, ibis )
    # Convert the IBI values to heart rates
    heart_rates = {}
    for i in 1...ibis.size do
      tokens = ibis[i].split( ',' )
      new_time = base_time + tokens[0].to_f
      time_str = "#{new_time.day}#{new_time.hour}#{new_time.min}"
      heart_rates[ time_str ] = [] if heart_rates[ time_str ].nil?
      heart_rates[ time_str ] << 60.0 / tokens[1].to_f
    end  # do

    min_rates = []
    loop_time = start_time
    while ( loop_time < end_time ) do
      min_rates << average_rate( heart_rates[ "#{loop_time.day}#{loop_time.hour}#{loop_time.min}" ] ).to_i
      loop_time += 60
    end  # do
    
    return min_rates.join( ',' )
  end  # ibi_to_heart_rate
    
  ###############################################################################
  def compress( lines )
    # Skip two header lines
    counts = []
    value = lines[2]
    count = 1
    for i in 3...lines.size do
      if ( lines[i] == value )
        count += 1
      else
        # Compress the duplicate values with count.
        if (count > 1 )
          counts << "#{value}:#{count}"
        else
          counts << value
        end  # if
        value = lines[i]
        count = 1
      end  # if
    end  # for
  
    # Add the last value observed.
    if (count > 1)
      counts << "#{value}:#{count}"
    else
      counts << value
    end  # if
  
    return counts
  end  # compress
  
  ###############################################################################
  def load_continuous( name, contents, individual_id, instrument_id, attachment_id )
    return if (name == "ACC.csv") || (name == "BVP.csv")
    lines = contents.split( "\n" )
    
    start_time = Time.at( lines[0].to_f )
    # start_time = Time::utc( utc_time.year, utc_time.mon, utc_time.day, utc_time.hour, utc_time.min, utc_time.sec, utc_time.usec )
    sample_rate = lines[1].to_f
    return if (sample_rate < 1.0)
    end_time = start_time + (lines.size - 2).to_f/sample_rate
    
    puts "##### start_time: #{start_time}"
    puts "##### end_time: #{end_time}"
    
    values = compress( lines )
    tokens = name.split( "." )
    load_monitor_data( tokens[0].downcase, individual_id, instrument_id, attachment_id, start_time, end_time, values, sample_rate.to_i, sample_rate.to_i*3600 )
  end  # load_continuous
 
  ###############################################################################
  def load_contents( name, contents, individual_id, instrument_id, attachment_id )
    puts "EmpaticaLoader: name: #{name}"
    if (name != "IBI.csv")
      load_continuous( name, contents, individual_id, instrument_id, attachment_id )
      return
    end  # if

    ibis = contents.split( "\n" )
    return if ibis.size < 2

    header = ibis[0].split( ',' )
    ibi_first = ibis[1].split( ',' )
    ibi_last = ibis[-1].split( ',' )
    
    base_time = Time.at( header[0].to_f )
    start_time = Time.at( header[0].to_f + ibi_first[0].to_f )
    end_time   = Time.at( header[0].to_f + ibi_last[0].to_f )

    puts "##### start_time: #{start_time}"
    puts "##### end_time: #{end_time}"

    heart_rates = ibi_to_heart_rate( base_time, start_time, end_time, ibis )
    load_monitor_data( "heart_rate", individual_id, instrument_id, attachment_id, start_time, end_time, heart_rates, 0, 60 )
    
  end  # load_contents
  
  
  ###############################################################################
  def load_monitor_data( itype_name, individual_id, instrument_id, attachment_id, start_time, end_time, values, points_second, points_hour )
    itype = Itype.where( name: itype_name ).take
    itype = Itype.create( name: itype_name, category: "Health Monitor" ) if itype.nil?
    
    MonitorDatum.where(individual_id: individual_id, instrument_id: instrument_id, itype_id: itype.id, start_time: start_time, end_time: end_time).first_or_create.
        update_attributes( individual_id: individual_id, instrument_id: instrument_id,
        attachment_id: attachment_id, itype_id: itype.id, start_time: start_time,
        end_time: end_time, points_per_second: points_second, points_per_hour: points_hour, data_vector: values )
  end  # load_monitor_data

    
  ###############################################################################
  
end  # class

