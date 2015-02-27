
require 'fasta_sequence.rb'
require 'output_file.rb'
require 'parse_pdb.rb'
require 'residue.rb'

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

################################################################################
# This class extracts the peptide sequences from a PDB file and writes them to
# a FASTA file.
class Pdb2fasta


################################################################################
def write_fasta( chains, filename )
  tokens = filename.split( '.' )
  fasta_file = OutputFile.new( tokens[0] + ".fa" )
  fasta_file.open_file
  puts "Writing FASTA sequences to #{tokens[0]}.fa\n" 

  chains.each do |chain|
    seq_name =  "#{tokens[0]}_#{chain[0].chain}" 

    seq = ""
    chain.each do |residue|
      seq += residue.amino_acid
    end  # do

    fasta_seq = FastaSequence.new( seq_name, "", seq, "aa" )

    # Write out the FASTA sequence.
    fasta_file.write( fasta_seq.to_string )
  end  # do

  fasta_file.close_file
end  # write_fasta

end  # class Pdb2fasta


################################################################################
def pdb2fasta_main( filename )
  puts "usage: ruby pdb2fasta.rb file.pdb\n" if ARGV.length < 1
  filename = ARGV[0] if ARGV.length >= 1

  app = Pdb2fasta.new

  pdb_parser = ParsePdb.new
  chains = pdb_parser.parse_file( filename )

  app.write_fasta( chains, filename )
end  # method test_pdb2fasta

# test_pdb2fasta( "1RVX.pdb" )
pdb2fasta_main( "3B7E.pdb" )

