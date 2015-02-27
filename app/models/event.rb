
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

class Event

  attr_accessor :start, :end, :title, :classname, :editable, :allDay, :activity_id, :individual_id, :itype_id, :image_id, :attachment_id, :note_id, :activity_name, :intensity, :qualifier

  def initialize(activity)
    @start = activity.start_time
    @end = activity.end_time
    @title = activity.activity_name
    
    @activity_id = activity.id
    @individual_id = activity.individual_id
    @itype_id = activity.itype_id
    @image_id = activity.image_id
    @attachment_id = activity.attachment_id
    @note_id = activity.note_id
    @activity_name = activity.activity_name
    @intensity = activity.intensity
    @qualifier = activity.user.qualifier
    
    @classname = "calendar-events"
    @editable = true
    @allDay = false
  end  # initialize
  
end  # Event
