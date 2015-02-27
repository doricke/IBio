
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

class Attachment < ActiveRecord::Base

  belongs_to :activity

  has_many :itype

  validates_presence_of :name
  
####################################################################################################
  def self.getNames(individual_id)
    files = Attachment.connection.select_rows("SELECT id,instrument_id,itype_id,name,content_type,created_at,is_parsed FROM attachments")
    attachments = []
    files.each do |file|
      attachment = Attachment.new(instrument_id: file[1], itype_id: file[2], name: file[3],
          content_type: file[4], created_at: file[5], is_parsed: file[6])
      attachment.id = file[0].to_i
      attachments << attachment
    end  # do
    return attachments
  end  # getNames
    
####################################################################################################
  def datafile=(input_data)
    return nil if input_data == "" #no file name was entered
    # self.file_name = base_part_of(input_data.original_filename)
    self.name = input_data.original_filename
    self.content_type = input_data.content_type.chomp
    self.file_binary = input_data.read
    self.file_text = self.file_binary
    self.is_parsed = false
    self.created_at = Time::now
  end  # datafile
  
####################################################################################################
  def parse_file(guid2, attachment_id)
    instrument = Instrument.find(self.instrument_id)
    
    # Parse Fitbit file.
    if ( instrument.name == "Basis watch" )
      loader = BasisLoader.new
      loader.load_contents( self.file_text, self.individual_id, self.instrument_id, self.id )    
      self.is_parsed = true
      self.save
    end  # if
    
    # Parse Jawbone file.
    if ( instrument.name == "Jawbone" )
      loader = JawboneLoader.new
      loader.load_contents( self.file_text, self.individual_id, self.instrument_id )
      self.is_parsed = true
      self.save
    end  # if
    
    # Parse Fitbit file.
    if ( instrument.name == "Fitbit" )
      loader = FitbitLoader.new
      loader.load_contents( self.file_text, self.individual_id, self.instrument_id )    
      self.is_parsed = true
      self.save
    end  # if
    
    # Parse 23andMe SNP files.
    if ( instrument.name == "SNP chip" ) 
      itype = Itype.find( self.itype_id )
      if ( itype.name == "23andMe" )
        exp_name = "23andMe SNP profile"
        loader = SnpsLoader.new
        loader.load_contents( self.file_text, guid2, self.individual_id, self.instrument_id, self.itype_id, exp_name, self.id )
        self.is_parsed = true
        self.save
      end  # if
    end  # if
    
    # Parse Moves files.
    if ( instrument.name == "Android Phone" ) || ( instrument.name == "IPhone" )
      itype = Itype.find( self.itype_id )
      if ( itype.name == "Moves app" )
        loader = MovesLoader.new
        loader.load_contents( self.file_text, self.individual_id, self.instrument_id, self.itype_id, self.id )
        self.is_parsed = true
        self.save
      end  # if
    end  # if
        
    # Parse My Tracks files.
    if ( instrument.name == "Android Phone" ) || ( instrument.name == "IPhone" )
      itype = Itype.find( self.itype_id )
      if ( itype.name == "My Tracks app" )
        loader = MyTracksLoader.new
        loader.load_contents( self.file_text, self.individual_id, self.instrument_id, self.itype_id, self.id )
        self.is_parsed = true
        self.save
      end  # if
    end  # if
    
    # Parse Iphone Sleep Cycle files.
    if ( instrument.name == "IPhone" )
      itype = Itype.find( self.itype_id )
      if ( itype.name == "Sleep Cycle app" )
        loader = SleepCycleLoader.new
        loader.load_contents( self.file_text, self.individual_id, self.instrument_id, self.itype_id, self.id )
        self.is_parsed = true
        self.save
      end  # if
    end  # if
    
    
  end  # parse_file

####################################################################################################

end  # class
