
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

class Image < ActiveRecord::Base
    
  belongs_to :activity
    
  validates_presence_of :name
  validates_presence_of :content_type
    
  #############################################################################
  def self.load_image(individual_id, image_name, image_type)
    in_file = InputFile.new('public/images/' + image_name)
    in_file.open_file
    picture = in_file.read_binary
    in_file.close_file
    
    image = Image.new
    image.individual_id = individual_id
    image.name = image_name
    image.image_type = image_type
    image.content_type = image_type
    
    if ! picture.nil?
      image.image_blob = picture
      image.save
      return image.id
    end  # if

    return 0  # no image loaded
  end  # load_image

#############################################################################
  def datafile=(input_data)
    datafile(input_data)
  end  # datafile=

####################################################################################################
  def datafile(input_data)
    return nil if input_data == "" #no file name was entered
    self.name = input_data.original_filename
    self.image_type = input_data.content_type.chomp
    self.content_type = input_data.content_type.chomp
    self.image_blob = input_data.read
    self.created_at = Time::now
  end  # datafile

####################################################################################################
end  # class
