
# This class provides an object model for an input text file.
#
# Author::    	Darrell O. Ricke, Ph.D.  (mailto: d_ricke@yahoo.com)
# Copyright:: 	Copyright (c) 2000 Darrell O. Ricke, Ph.D., Paragon Software
# License::   	GNU GPL license  (http://www.gnu.org/licenses/gpl.html)
# Contact::   	Paragon Software, 1314 Viking Blvd., Cedar, MN 55011
#
#             	This program is free software; you can redistribute it and/or modify
#             	it under the terms of the GNU General Public License as published by
#             	the Free Software Foundation; either version 2 of the License, or
#             	(at your option) any later version.
#         
#             	This program is distributed in the hope that it will be useful,
#             	but WITHOUT ANY WARRANTY; without even the implied warranty of
#             	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#             	GNU General Public License for more details.
#
#               You should have received a copy of the GNU General Public License
#               along with this program. If not, see <http://www.gnu.org/licenses/>.
class InputFile

# the contents of the text file
attr_accessor :contents
# the current end-of-file status
attr_accessor :end_of_file
# the current line of the input text file.
attr_accessor :line 
# the name of the input text file.
attr_accessor :name

###############################################################################
# Create an input text file object for the named file.
def initialize( n )
  @contents = ""  # Contents of the text file
  @name = n			  # Input text file name
  @end_of_file = false		# End-of-file status
  @line = ""			# Current text line
end  # method initialize

###############################################################################
# Open the input text file.
def open_file
  @file = File.open( @name )
  @end_of_file = false			# not end of file
end  # method open_file

###############################################################################
# Close the input text file.
def close_file
  @file.close unless @file.nil?
  @end_of_file = true
end  # method close_file

###############################################################################
# Get the next line from the input text file.
def get_line
  if ( @line == nil )  
    return "" 
  end  # if
  return @line
end  # method get_line

###############################################################################
# Get the name of the input text file.
def get_file_name
  return @name
end  # method get_file_name

###############################################################################
# Get the end-of-file status of the input text file.
def is_end_of_file?
  return @end_of_file
end  # method is_end_of_file

###############################################################################
# Read in the text file.
def read_file
  while ( is_end_of_file? == false )
    l = next_line()
    # puts "line: #{l}"
    
    @contents += l if (is_end_of_file? == false)
  end  # while
  
  # puts "Contents:\n#{@contents}"
  return @contents
end # method read_file

###############################################################################
# Set the name of the input text file.
def set_file_name(value)
  @name = value			# file name
end  # method set_file_name

###############################################################################
# Get the next text line from the input text file.
def next_line()
  # Check for end of file.
  if ( ( @line == nil ) || ( @end_of_file == true ) ) 
    return "" 
  end  # if

  # try block for readline
  begin
    @line = @file.readline()

    # Check for end of file
    if ( @line == nil )  
      @end_of_file = true
      @line = ""
    end  # if
  rescue
    @end_of_file = true
  end  # begin

  return @line		# return the current line
end  # method next_line

###############################################################################
def read_binary
  @contents = nil
  begin
    @file.binmode
    @contents = @file.read unless @file.nil?
  rescue
    print "Zap error"
  end
  
  return @contents
end  # method read_binary

###############################################################################
end  # class InputFile

###############################################################################
# Test module.
def test
  inf = InputFile.new( "test.data" )
  inf.open_file()
  while ( inf.is_end_of_file? == false )
    l = inf.next_line()
    if ( inf.is_end_of_file? == false )
      print "Line: " 
      print l
    end  # if
  end  # while
end # method test

# test()
