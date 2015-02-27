require 'tools.rb'

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

class CoreTempCalculate
    
  ###############################################################################
  A = 1.0
  GAMMA = 0.022 * 0.022
  B_0 = -7887.1
  B_1 = 384.4286
  B_2 = -4.5714
  SIGMA = 18.88 * 18.88
  
  ###############################################################################
  def calculate_all( data_entry_id )
      
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    heart_rate_type = Itype.where(name: "heart_rate").take
    monitor_data = MonitorDatum.where(individual_id: individual.id, itype_id: heart_rate_type.id, points_per_hour: 60 ).to_a
    instruments_hash = Tools::to_hash(Instrument.all)

    core_temp_type = Itype.where(name: "core_temp").take
    core_temp_type = Itype.create(name: "core_temp", category: 'calculated') if core_temp_type.nil?

    monitor_data.each do |monitor_datum|
      # core_temps = calculate_session( monitor_datum, core_temp_type.id, 98.6)
      core_temps = calculate_session( monitor_datum, core_temp_type.id, 37.0)
      record_core_temp( monitor_datum, core_temps, core_temp_type.id )
      # return
    end  # do

  end  # calculate_all
  
  ###############################################################################
  def calculate_session( monitor_datum, core_temp_type_id, core_temp_start )
    data = []
    x = core_temp_start
    v = 0
    
    st = monitor_datum.start_time
    loop_time = Time::local( st.year, st.mon, st.day, st.hour, st.min )
    # puts "#{monitor_datum.instrument_id}\t#{devices[monitor_datum.instrument_id]}\t#{monitor_datum.data_vector}"
    data_vector = monitor_datum.data_vector.split( "," )
    data_vector.each do |beat|
      hr = 0.0
      hr = beat.to_f if beat.size > 0
      x_pred = A * x                                                  # Equation 3
      v_pred = (A*A)*v + GAMMA                                        # Equation 4
      c_vc = 2.0 * B_2 * x_pred + B_1                                 # Equation 5
      k = (v_pred * c_vc)/((c_vc*c_vc)*v_pred+SIGMA)                  # Equation 6
      x = x_pred + k * (hr - (B_2 * (x_pred*x_pred)+B_1*x_pred+B_0)) if (hr >= 40.0) && (hr <= 240.0)
      # Equation 7
      v = (1.0 - k*c_vc)*v_pred                                       # Equation 8
      if (hr >= 40.0) && (hr <= 240.0)
        data << "%3.2f" % x
      else
        data << ""
      end  # if
    end  # do
    
    return data.join( ',' )
  end  # calculate_session
  
  ###############################################################################
  def record_core_temp( monitor_datum, core_temps, core_temp_id )
    puts "Individual: #{monitor_datum.individual_id}"
    puts "Instrument_id: #{monitor_datum.instrument_id}"
    puts "From #{monitor_datum.start_time} to #{monitor_datum.end_time}"
    puts "Heart rate: #{monitor_datum.data_vector}"
    puts "Core temps: #{core_temps}"
    monitor_core = MonitorDatum.where(individual_id: monitor_datum.individual_id,
        itype_id: core_temp_id,
        instrument_id: monitor_datum.instrument_id,
        start_time: monitor_datum.start_time).first_or_create.update_attributes(individual_id: monitor_datum.individual_id,
            instrument_id: monitor_datum.instrument_id,
            device_id: monitor_datum.device_id,
            itype_id: core_temp_id,
            start_time: monitor_datum.start_time,
            end_time: monitor_datum.end_time,
            points_per_hour: monitor_datum.points_per_hour,
            data_vector: core_temps)
  end  # record_core_temp
  
  ###############################################################################
  
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = CoreTempCalculate.new
  if ARGV.length >= 1
    app.calculate_all( ARGV[0].delete( '"' ) )
  end  # if
end  # main_method

main_method
