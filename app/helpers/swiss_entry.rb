
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

###############################################################################
# This class provides an object model for a SwissProt text entry.
class SwissEntry

# annotation - current sequence annotation
attr_accessor :annotation

# sequence_data - current sequence data.
attr_accessor :sequence_data
# sequence_name - current sequence name.
attr_accessor :sequence_name


###############################################################################
# Create a new SwissProt entry object.
def initialize( text_lines )
  lines = text_lines.split( "\n" )

  @annotation = {}
  lines.each do |line|
    key = line[ 0..1]
    @annotation[ key ] = [] if @annotation[ key ].nil?
    @annotation[ key ] << line[5..-1]
  end  # do
  
  @sequence_name = ""
  @sequence_data = ""

  @sequence_name = @annotation[ 'ID' ][ 0 ][ 0..10 ].strip if ! @annotation[ 'ID' ].nil?
  @sequence_data = @annotation[ '  ' ].join.delete( ' ' ) if ! @annotation[ '  ' ].nil?
end  # method initialize


###############################################################################

end  # SwissEntry


###############################################################################
