
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

class Place < ActiveRecord::Base
  private

###########################################################################################################
  #returns an array of the 5 closest places to a given location, in ascending order
  def self.get_closest(loc)
    distances = {}
    #distance[place] = place's distance to given loc
    Place.all.map{|p| distances[p] = Place.get_distance(loc, p)}

    #gets the closest 5 places to the given location
    distances.sort_by{|id, dist| dist}[0...5]
  end

###########################################################################################################
  #uses the haversine formula to calculate short distances in km
  # between two points, optimized for 39 degrees north of equator
  # http://andrew.hedges.name/experiments/haversine/
  def self.get_distance(loc, place)
    lat1 = loc.latitude
    lon1 = loc.longitude
    lat2 = place.latitude
    lon2 = place.longitude

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    #rad is the amount conversion factor from degrees to radians
    rad = Math::PI/180
    a = (Math.sin(dlat/2*rad))**2 + Math.cos(lat1*rad) * Math.cos(lat2*rad) * (Math.sin(dlon/2*rad))**2
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a) )
    (6373 * c).round(1)
  end  # get_distance
end  # class
