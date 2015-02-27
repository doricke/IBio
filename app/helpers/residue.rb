
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

################################################################################
# This class represents an amino acid from a PDB file.
class Residue

# amino acid residue single letter code
attr_accessor :amino_acid		

# amino acid residue three letter code
attr_accessor :residue

# structure chain
attr_accessor :chain

# amino acid structure coordinate position
attr_accessor :coordinate

# amino acid solvent accessibility
attr_accessor :solvent

# amino acid variation within a multiple sequence alignment
attr_accessor :variation


################################################################################
def initialize( res, chain_str, coord )
  @residue = res			# amino acid residue three letter code
  @chain = chain_str			# structure chain
  @coordinate = coord			# structure coordinate
  translate				# translate the three letter code
  @solvent = 0				# solvent accessibility
  @variation = 0
end  # initialize


################################################################################
# This method translates an amino acid 3 letter code into the 1 letter code.
def translate
  @amino_acid = self.translate( @residue )
end  # method translate

################################################################################
# This method translates an amino acid 3 letter code into the 1 letter code.
def self.translate( aa_residue )
  case aa_residue
    when 'ALA' then
      amino_acid = 'A'
    when 'ARG' then
      amino_acid = 'R'
    when 'ASN' then
      amino_acid = 'N'
    when 'ASP' then
      amino_acid = 'D'
    when 'ASX' then
      amino_acid = 'B'
    when 'CYS' then
      amino_acid = 'C'
    when 'GLU' then
      amino_acid = 'E'
    when 'GLN' then
      amino_acid = 'Q'
    when 'GLX' then
      amino_acid = 'Z'
    when 'GLY' then
      amino_acid = 'G'
    when 'HIS' then
      amino_acid = 'H'
    when 'ILE' then
      amino_acid = 'I'
    when 'LEU' then
      amino_acid = 'L'
    when 'LYS' then
      amino_acid = 'K'
    when 'MET' then
      amino_acid = 'M'
    when 'PHE' then
      amino_acid = 'F'
    when 'PRO' then
      amino_acid = 'P'
    when 'SER' then
      amino_acid = 'S'
    when 'THR' then
      amino_acid = 'T'
    when 'TRP' then
      amino_acid = 'W'
    when 'TYR' then
      amino_acid = 'Y'
    when 'VAL' then
      amino_acid = 'V'
    else
      amino_acid = '.'
  end  # case

  return amino_acid
end  # method translate


################################################################################
def to_string
  return @chain + " " + @residue + " " + @amino_acid + " " + @coordinate +
    " " + @solvent.to_s + " " + @variation.to_s
end  # method to_string

end  # class Residue


################################################################################
def test_residue
  aa1 = Residue.new( "VAL", 'A', 1 )
  aa2 = Residue.new( 'ARG', 'B', 1 )
  aa3 = Residue.new( 'MET', 'B', 2 )
end  # method test_residue

# test_residue()

