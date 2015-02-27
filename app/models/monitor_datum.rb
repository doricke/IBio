
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

class MonitorDatum < ActiveRecord::Base

  #converts minutes after midnight to military time
  def self.min_to_mil(min)
    h = (min / 60).to_s.rjust(2, '0')
    m = (min % 60).to_s.rjust(2, '0')
    "#{h}#{m}"
  end

  def self.get_surfacemap_data(individual_id, itype_id, instrument_id, target_day)
    data = {}
    puts "model.get_surfacemap_data: individual_id: #{individual_id}, itype_id: #{itype_id}, instrument_id: #{instrument_id}, day: #{target_day}"

    collection = MonitorDatum.where(individual_id: individual_id, instrument_id: instrument_id, itype_id: itype_id, start_time: target_day...(target_day+7.days), points_per_hour: 60).to_a

    # 7 days, 1440 minutes per day (60 * 24)
    ys = Array.new(1440 * 7, 0)

    #parses out the relevant portion of the data_vector, with space fill if needed to get the relevant data for the time period
    collection.each do |md|
      s_time = (md.start_time.yday - target_day.yday) * 1440 + md.start_time.hour * 60 + md.start_time.min
      puts "date: #{md.start_time}, s_time: #{s_time}"
      # puts "instrument: #{md.instrument_id} data_vector: #{md.data_vector}"
      data_vector_array = md.data_vector.split(',', -1).map{ |e| e.to_i }
      data_vector_array.each do |beat_per_minute|
        ys[ s_time ] = beat_per_minute
        s_time += 1
      end  # do
    end  # do

    # puts "**** ys: #{ys}"

    # Filter noise in data
    for i in 2...(ys.size-2) do
      ys[i] = 0 if (ys[i] > 100) && ((ys[i-2] == 0) || ( ys[i-1] == 0 ) || ( ys[i+1] == 0 ) || (ys[i+2] == 0))
      
      # puts "**** #{i} #{ys[(i-2)..(i+2)]}" if (ys[i] > 120)
    end  # for

    surface_data = {}
    surface_data[:vol] = ys
    surface_data[:xs] = (0...1440).map{ |n| n.to_s}.to_a
    surface_data[:xs_labels] = (0...1440).map{ |i| min_to_mil(i) }
    surface_data[:xs_label] = 'Time'
    surface_data[:zs] = (1..7).map{ |i| i.to_s }
    surface_data[:zs_labels] = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
    surface_data[:zs_label] = "Week of #{target_day.strftime('%x')}"
    data['surfacemap'] = surface_data
    data
end  # get_surfacemap_data

end  # class
