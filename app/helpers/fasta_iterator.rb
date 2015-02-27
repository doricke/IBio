
# This class provides an object model for accessing FASTA sequences from
# a FASTA sequence library input text file.
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
         
require 'input_file.rb'
require 'fasta_sequence.rb'
require 'seq_tools.rb'

###############################################################################
class FastaIterator < InputFile

# Attributes:
# - end_of_file - the current end-of-file status (0 = false; 1 = true)
# - line - the current line of the input text file.
# - name - the name of the input text file.

# fasta sequenes read from the current FASTA file
attr_reader :fastas


###############################################################################
# Create the FastaIterator object on named FASTA sequence library file.
def initialize( name )
  super( name )		# initialize InputFile
  @fasta = nil
  @fastas = {}
end  # method initialize


###############################################################################
# Return all of the FASTA sequences in a hash keyed by sequence name.
def read_fastas
  @fastas = {}
  while ( self.is_end_of_file? == false )
    seq = self.next_sequence
    seq.sequence_data = SeqTools::trim_ns( seq.sequence_data ) if ! seq.nil?
    @fastas[ seq.sequence_name ] = seq if (! seq.nil?) && (seq.sequence_data.length > 0)
  end  # while

  return @fastas
end  # method read_fastas


###############################################################################
# Return all of the FASTA sequence names in a hash keyed by sequence name.
def read_names
  @names = {}
  while ( self.is_end_of_file? == false )
    seq = self.next_sequence
    @names[ seq.sequence_name ] = true if (! seq.nil?) && (seq.sequence_data.length > 0)
  end  # while

  return @names
end  # method read_names


###############################################################################
# Return all of the FASTA sequences in to an array.
def fastas_to_array
  @fastas = []
  while ( self.is_end_of_file? == false )
    seq = self.next_sequence
    if (! seq.nil?) && (seq.sequence_data.length > 0)
      @fastas << seq 
    end  # if
  end  # while

  return @fastas
end  # method fastas_to_array


###############################################################################
# Return the next FASTA header line - skipping sequence data.
def next_header
  # Find the start of the next sequence.
  while ( ( self.is_end_of_file? == false ) &&
          ( not(@line =~ /^>/) ) )
    self.next_line()
  end  # while

  # Check for end of file.
  return "" if ( @end_of_file == 1 )

  return @line		# return the header line
end  # method next_header


###############################################################################
# Get the next sequence from the FASTA library file.
def next_sequence
  # Advance to the next FASTA header line.
  self.next_header()

  # Create a new FASTA sequence object.
  @fasta = FastaSequence.new( "", "", "", "" )

  # Parse the header line.
  @fasta.parse_header( @line.chomp( "\n" ) )

  # Read in the sequence data.
  self.next_line()
  seq = ""
  while ( ( self.is_end_of_file? == false ) &&
          ( not(@line =~ /^>/) ) )
    seq = seq + @line.chomp()
    self.next_line()
  end  # while
  @fasta.sequence_data = seq

  return @fasta
end  # method next_sequence

end  # class FastaIterator


###############################################################################
# Testing module.
def test_fasta_iterator
  in_fasta = FastaIterator.new( "test.data" )
  in_fasta.open_file
  while ( in_fasta.is_end_of_file? == false )
    fasta = in_fasta.next_sequence
    if ( fasta != nil )
      print "name = ", fasta.sequence_name, " "
      print "desc = ", fasta.sequence_description, "\n"
      print "seq  = ", fasta.sequence_data, "\n"
      puts
    end  # if
  end  # while
  in_fasta.close_file
end  # method test_fasta_iterator


###############################################################################
# test_fasta_iterator()

