
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
         
require 'input_file.rb'
require 'swiss_entry.rb'

###############################################################################
# This class provides an iterator class for the SwissProt database.
class SwissIterator < InputFile

# Attributes:
# - end_of_file - the current end-of-file status (0 = false; 1 = true)
# - line - the current line of the input text file.
# - name - the name of the input text file.

# current SwissProt entry
attr_reader :swiss


###############################################################################
# Create the SwissIterator object on named FASTA sequence library file.
def initialize( name )
  super( name )		# initialize InputFile
  @swiss = nil
end  # method initialize


###############################################################################
# Get the next entry from the SwissProt text file.
def next_entry
  @swiss = nil
  entry = ""

  # Read in the SwissProt entry.
  self.next_line()
  while ( ( self.is_end_of_file? == false ) &&
          ( ! @line.nil? ) &&
          ( @line[0] != '/' ) )
    entry = entry + @line
    self.next_line()
    # puts "line: #{@line}"
  end  # while

  @swiss = SwissEntry.new( entry ) if entry.size > 0
  return @swiss
end  # method next_entry

end  # class SwissIterator


###############################################################################
# Testing module.
def test_swiss_iterator( filename )
  in_swiss = SwissIterator.new( filename )
  in_swiss.open_file
  while ( in_swiss.is_end_of_file? == false )
    swiss = in_swiss.next_entry
    if ( swiss != nil )
      print "name = ", swiss.sequence_name, " "
      # print "desc = ", swiss.sequence_description, "\n"
      print "seq  = ", swiss.sequence_data, "\n"
      puts
    end  # if
  end  # while
  in_swiss.close_file
end  # method test_swiss_iterator


###############################################################################
# test_swiss_iterator( "FA9_HUMAN" )

