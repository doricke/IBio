
require 'input_file.rb'

class AtomsLoad

  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    info_file = InputFile.new(filename)
    info_file.open_file
    pdb_name = ""
    structure_id = nil
    while ( info_file.is_end_of_file? == false )
      line = info_file.next_line()
      pdb_name, structure_id = process_line( line, pdb_name, structure_id ) if ( info_file.is_end_of_file? == false )
    end  # while
    info_file.close_file
  end # load_data
  
  ###############################################################################
  def process_line( line, pdb_name, structure_id )
    tokens = line.split( "\t" )
    if ( tokens[0] != pdb_name )
      pdb_name = tokens[0]
      structure = Structure.where(name: pdb_name).take
      structure_id = structure.id
    end  # if
    
    aa_residue = tokens[3].to_i
    puts "structure_id: #{structure_id}, chain: #{tokens[1]}, pdb: #{pdb_name}"
    # Atom.where(structure_id: structure_id, chain: tokens[1], atom_start: tokens[5].to_i).first_or_create.update_attributes(structure_id: structure_id, chain: tokens[1], residue: tokens[2], aa_residue: aa_residue, aa_name: tokens[4], atom_start: tokens[5].to_i, atom_end: tokens[6].to_i)
    atom = Atom.where(structure_id: structure_id, chain: tokens[1], aa_name: tokens[4]).take
    atom.update_attributes(aa_residue: aa_residue) if ! atom.nil?
    
    return pdb_name, structure_id
  end # process line
end # class

###############################################################################
def main_method
  app = AtomsLoad.new
  app.load_data( "atoms2.csv" )
end  # main_method

main_method
