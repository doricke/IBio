
  pdbs = ["1RFN", "2WPH", "2WPI", "2WPJ", "2WPK", "2WPL", "2WPM", "3KCG", "3LC3", "3LC5"]

  pdbs.each do |pdb_name|
    structure = Structure.where(name: pdb_name).take

    atoms = Atom.where(structure_id: structure.id).to_a
    atoms.each do |atom|
      puts "#{structure.name}\t#{atom.chain}\t#{atom.residue}\t#{atom.aa_residue}\t#{atom.aa_name}\t#{atom.atom_start}\t#{atom.atom_end}"
    end  # do
  end  # do


