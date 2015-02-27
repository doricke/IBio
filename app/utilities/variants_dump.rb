
  individual = Individual.where(data_entry_id: "135").take

  puts "guid2: #{individual.guid2}"

  variants = Variant.where(guid2: individual.guid2).to_a

  seqs = Hash[Biosequence.pluck(:id, :name)]

  seq_genes = Hash[Biosequence.pluck(:id, :gene_id)]

  aa_seq = Hash[Biosequence.pluck(:id, :aa_sequence)]

  disease_genes = Hash[DiseaseGene.pluck(:gene_id, :disease_id)]

  diseases = Hash[Disease.pluck(:id, :name)]

  structures = Hash[Structure.pluck(:id, :name)]

  seq_structures = Hash[StructureSequence.pluck(:biosequence_id, :structure_id)]

  variants.each do |variant|
    seq_name = seqs[variant.biosequence_id]
    seq_gene_id = seq_genes[variant.biosequence_id]
    disease_id = disease_genes[seq_gene_id]
    disease = diseases[ disease_id ]
    known = Variant.where(is_public: true, biosequence_id: variant.biosequence_id, sequence_start: variant.sequence_start).take
    str = ""
    str = "#{known.sequence_start}:#{known.mutation}" if ! known.nil?
    structure_id = seq_structures[variant.biosequence_id]
    pdb_name = ""
    pbd_name = structures[structure_id] if ! structure_id.nil?
    puts "#{variant.guid2}\t#{variant.mutation}\t#{variant.mutation_type}\t#{seq_name}\t#{aa_seq[variant.biosequence_id].size}\t#{disease}\t#{str}\t#{structure_id}\t#{pdb_name}"
  end  # do
