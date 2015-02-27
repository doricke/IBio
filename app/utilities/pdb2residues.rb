
require 'input_file.rb'
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

class Pdb2residues

##########################################################################################################
  def parse_contents( structure_id, contents )
    if contents.nil?
      # puts "No structure: #{structure_id}"
      return
    end  # if
    
    # Delete all atoms for this structure.
    atoms = Atom.where(structure_id: structure_id).to_a
    atoms.each do |atom|
      atom.delete
    end  #  end
    
    atom_start = 0
    atom_end = 0
    last_chain = ""
    residue = ""
    last_coord = ""
    last_chain = ""
    lines = contents.split( "\n" )
    lines.each do |line|
      puts "#{line}"
      if line[ 0..3 ] == "ATOM"
        atom = line[ 4..10 ].to_i
        aa3 = line[ 17, 3 ].strip
        chain = line[ 21, 2 ].strip
        coord = line[ 23, 5 ].strip
        atom_start = atom if atom_start < 1
        if ( coord != last_coord ) && ( last_coord.size > 0 )
          res = Residue.translate( residue )
          Atom.create(structure_id: structure_id, chain: last_chain, residue: res, aa_name: last_coord, atom_start: atom_start, atom_end: atom_end )
          puts "#{atom_start}\t#{atom_end}\t#{residue}\t#{res}\t#{last_chain}\t#{last_coord}"
          atom_start = atom
        end  # if
        
        atom_end = atom
        last_coord = coord
        residue = aa3
        last_chain = chain
      else
        if ( atom_start > 0 ) && ( last_coord.size > 0 )
          res = Residue.translate( residue )
          Atom.create(structure_id: structure_id, chain: last_chain, residue: res, aa_name: last_coord, atom_start: atom_start, atom_end: atom_end )
          puts "#{atom_start}\t#{atom_end}\t#{residue}\t#{res}\t#{last_chain}\t#{last_coord}"
        end  # if
        last_coord = ""
        atom_start = 0
        atom_end = 0
      end  # if
    end  # do

    if ( last_coord.size > 0 )
      res = Residue.translate( residue )
      Atom.create(structure_id: structure_id, chain: last_chain, residue: res, aa_name: last_coord, atom_start: atom_start, atom_end: atom_end )
    end  # if
  end  # method parse_contents
  
  ##########################################################################################################

end  # Pdb2residues

##########################################################################################################
def test_pdb2residue
  app = Pdb2residues.new
  
  atom_structures = Atom.uniq.pluck(:structure_id)
  done = {}
  atom_structures.each do |structure_id|
    done[ structure_id ] = true
  end  # do
  
  # structure = Structure.find(6)
  # app.parse_contents( structure.id, structure.pdb )
  @structures = Structure.all(:select => 'id')
  @structures.each do |id|
    if ! done[ id ]
      structure = Structure.find(id)
      puts "Loading #{structure.name}"
      app.parse_contents( structure.id, structure.pdb )
    end  # if
  end  # do
end  # test_pdb2residue


##########################################################################################################
test_pdb2residue
