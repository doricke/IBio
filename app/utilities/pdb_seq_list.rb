
  structures_hash = Hash[Structure.pluck(:id, :name)]

  biosequences_hash = Hash[Biosequence.pluck(:id, :name)]

  pdb_seqs = StructureSequence.all

  pdb_seqs.each do |pdb_seq|
    pdb_name = structures_hash[ pdb_seq.structure_id ]
    seq_name = biosequences_hash[ pdb_seq.biosequence_id ]
    puts "#{pdb_name}\t#{seq_name}"
  end  # do

