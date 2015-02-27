require 'swiss_entry.rb'
require 'swiss_iterator.rb'

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

class SwissLoader
  
  ###############################################################################
  def load_gene( entry, organism_id )
    gns = entry.annotation[ "GN" ]
    return nil if gns.nil?
    
    parts = gns[ 0 ].split( ';' )
    gn = parts[ 0 ][ 5..-1 ]
    i = gn.index( '{' )
    gn = gn[ 0...(i-1)] if ! i.nil?
    gn = gn[ 0...16 ] if gn.size > 16
    de = entry.annotation[ "DE" ][ 0 ][ 14..-1 ].delete( ';' )
    de = de[ 0...240 ] if de.size > 240
    gi = ""
    if ! entry.annotation[ "OX" ].nil?
      gi = entry.annotation[ "OX" ][ 0 ][ 11..-1 ].delete( ';' )
      i = gi.index( ' ' )
      gi = gi[ 0...i ] if ! i.nil?
    end  # if
    
    gene = Gene.find_by_organism_id_and_name( organism_id, gn )
    return gene if ! gene.nil?

    gene = Gene.create( organism_id: organism_id, name: gn, gene_symbol: gn, ncbi_gene_id: gi, description: de, updated_at: Time::now )
    return gene
  end  # load_gene
  
  ###############################################################################
  def load_block( gene_id, block )
    if ( block[ 0..6 ] != "DISEASE" )
      return
    end  # if
    
    index = block.index( "[MIM:" )
    return if index.nil?
    disease_name = block[ 9...(index-1) ]
    disease_name = disease_name[ 0...240 ] if disease_name.size > 240
    last = block.index( "]" )
    mim = block[ (index+5)...last ]
    
    last = block.index( "Note=" )
    comment = block
    if ! last.nil?
      comment = block[ 0..(last-1) ]
      comment = comment[ 0...2048 ] if comment.size > 2048
    end  # if

    # Find or create the disease entry.
    disease = Disease.find_by_mim_id( mim )
    if disease.nil?
      # Find or create the note.
      note = Note.find_by_comment( comment )
      note = Note.create( comment: comment ) if note.nil?
      
      disease = Disease.create( note_id: note.id, mim_id: mim, name: disease_name )
    end  # if
    
    # Find or create the disease gene entry.
    disease_gene = DiseaseGene.find_by_disease_id_and_gene_id( disease.id, gene_id )
    if disease_gene.nil?
      DiseaseGene.create( disease_id: disease.id, gene_id: gene_id )
    end  # if
  end  # load_block
  
  ###############################################################################
  def load_diseases( entry, gene_id )
    ccs = entry.annotation[ "CC" ]
    if ccs.nil?
      return
    end  # if
    block = ""
    for i in 0...ccs.size do
      if ( ccs[ i ][ 0..2 ] == "-!-" )
        if ( block.size > 0 )
          load_block( gene_id, block )
        end  # if
        block = ccs[ i ][ 4..-1 ]
      else
        block += " " + ccs[ i ][ 4..-1 ]
      end  # if
    end  # for
  end  # load_diseases
  
  ###############################################################################
  def load_domains( entry, biosequence_id, gene_id )
    fts = entry.annotation[ "FT" ]
    if fts.nil?
      return
    end  # if
    fts.each do |ft|
      if ( ft[ 0..5 ] == "DOMAIN" )
        aa_start = ft[ 10..14 ].to_i
        aa_end = ft[ 16..21 ].to_i
        name = ft[ 29..-1 ]
        name = name[ 0..-2 ] if name[ -1 ] == '.'
        domain = Domain.find_by_name( name )
        domain = Domain.create( name: name ) if domain.nil?
        
        seq_domain = BiosequenceDomain.find_by_biosequence_id_and_domain_id( biosequence_id, domain.id )
        if seq_domain.nil?
          BiosequenceDomain.create( biosequence_id: biosequence_id, domain_id: domain.id, seq_start: aa_start, seq_end: aa_end )
        end  # if
      end  # if
      
      if ( ft[ 0..2 ] == "MIM" )
        load_mim( ft, gene_id )
      end  # if
      
      if ( ft[ 0..6 ] == "VARIANT" )
        load_variant( ft, biosequence_id )
      end  # if
    end  # do
  end  # load_domains
  
  ###############################################################################
  def load_go( entry, gene_id )
    drs = entry.annotation[ 'DR' ]
    return if drs.nil?
    
    go_types = {}
    go_types["C"] = Itype.where(name: "Component", category: "GO").take
    go_types["C"] = Itype.create(name: "Component", category: "Go") if go_types["C"].nil?
    go_types["F"] = Itype.where(name: "Function", category: "GO").take
    go_types["F"] = Itype.create(name: "Function", category: "Go") if go_types["F"].nil?
    go_types["P"] = Itype.where(name: "Process", category: "GO").take
    go_types["P"] = Itype.create(name: "Process", category: "Go") if go_types["P"].nil?
    
    drs.each do |dr|
      parts = dr.split( ';' )
      if ( parts[0] == "GO" )
        tokens = parts[2].split( ':' )
        go = Go.where(gene_id: gene_id, itype_id: go_types[ tokens[0] ], term: tokens[1])
        go = Go.create(gene_id: gene_id, itype_id: go_types[ tokens[0] ], term: tokens[1]) if go.nil?
      end  # if
    end  # do
  end  # load_go
  
  ###############################################################################
  def load_mim( ft, gene_id )
    parts = ft.split( ';' )
    mim = parts[1][ 1..-1 ]
    disease = Disease.find_by_mem_id( mim )
    if disease.nil?
      disease = Disease.create( mim_id: mim )
    end  # if
    
    disease_gene = DiseaseGene.find_by_disease_id_and_gene_id( disease.id, gene_id )
    DiseaseGene.create( disease_id: disease.id, gene_id: gene_id ) if disease_gene.nil?
  end  # load_mim
  
  ###############################################################################
  def load_variant( ft, biosequence_id )
    # puts "Variant: #{ft}"
    aa_start = ft[ 8..14 ].to_i
    aa_end = ft[ 16..21 ].to_i
    # aa_residue = ft[ 29..29 ]
    note_index = ft.index( " (in " )
    index = ft.index( " -> " )
    if (index.nil? && (! ft.index( "Missing" ).nil?))
      mut_residue = ""
    else
      mut_residue = ft[ (index+4)...note_index ] if ! note_index.nil?
    end  # if
    note = ""
    note_rec_id = nil
    if (! note_index.nil?)
      note = ft[ (note_index+5)..-1 ]
      index = note.index( ")." )
      note = note[ 0...index ] if ! index.nil?
      tokens = note.split( ';' )
      case tokens[1]
        when " mild"
          note = tokens[0] + ";" + tokens[1]
        when " servere"
          note = tokens[0] + ";" + tokens[1]
        when " moderate"
          note = tokens[0] + ";" + tokens[1]
        when " mild to moderate"
          note = tokens[0] + ";" + tokens[1]
        when " moderately severe"
          note = tokens[0] + ";" + tokens[1]
        else
          # puts ">>> tokens[1]: '#{tokens[1]}'"
          note = tokens[0]
      end  # case
      note_rec = Note.where(table_name: "Variant", comment: note).take
      note_rec = Note.create(table_name: "Variant", comment: note) if note_rec.nil?
      note_rec_id = note_rec.id
      # puts ">>>>>> note: #{note} note_rec.id: #{note_rec.id}"
    end  # if
    
    variant = Variant.find_by_biosequence_id_and_mutation_and_sequence_start( biosequence_id, mut_residue, aa_start )
    if variant.nil?
      Variant.create( biosequence_id: biosequence_id, note_id: note_rec_id, sequence_type: 'aa',
          mutation: mut_residue, mutation_type: 'missense', sequence_start: aa_start,
          sequence_end: aa_end, is_public: true )
    else
      variant.update_attributes( note_id: note_rec_id, mutation: mut_residue )
    end  # if
    
  end  # load_variant
  
  ###############################################################################
  def load_structures( entry, biosequence_id )
    drs = entry.annotation[ 'DR' ]
    return if drs.nil?
    
    drs.each do |dr|
      parts = dr.split( ';' )
      if ( parts[0] == "PDB" ) && ( parts[2] == " X-ray" )
        # puts "PDB line: #{dr}"
        pdb_name = parts[ 1 ][ 1..-1 ]
        # puts "PDB name: #{pdb_name}"
        structure = Structure.find_by_name( pdb_name )
        structure = Structure.create( name: pdb_name ) if structure.nil?
        
        res = parts[ 3 ][ 1..-3 ]
        chains = parts[ 4 ].delete( '.' ).split( ',' )
        chains.each do |segment|
          region = segment.split( '=' )
          if ! region[1].nil?
            tokens = region[1].split( '-' )
            aa_start = 0
            aa_start = tokens[0].to_i if ! tokens[0].nil?
            aa_end = 0
            aa_end = tokens[1].to_i if tokens.size > 1
            letters = region[0][ 1..-1].split( '/' )
            letters.each do |chain|
              structure_sequence = StructureSequence.find_by_structure_id_and_biosequence_id_and_chain( structure.id, biosequence_id, chain )
              if structure_sequence.nil?
                StructureSequence.create( structure_id: structure.id, biosequence_id: biosequence_id, chain: chain, resolution: res, aa_start: aa_start, aa_end: aa_end)
              else
                structure_sequence.update_attributes( resolution: res, aa_start: aa_start, aa_end: aa_end )
              end  # if
            end  # do
          end  # if
        end  # do
      end  # if
    end  # do
  end  # load_structures
  
  ###############################################################################
  def get_accession( entry )
    ac = entry.annotation[ 'AC' ][ 0 ]
    return "" if ac.nil?
    # puts "##### ac: '#{ac}"
    tokens = ac.split( ';' )

    accession = tokens[0]
    # puts "##### get_accession: #{accession}"
    return accession
  end  # get_accession
  
  ###############################################################################
  def load_entry( entry )
    os = entry.annotation[ 'OS' ][ 0 ]
    oc = entry.annotation[ 'OC' ][ 0 ]
    return if os.nil?
    # return if ! os.include?( "Homo sapiens" )
    return if (! oc.include?( "Chordata" )) && (! oc.include?( "Viruses" ) )
    
    # Find organism.
    os_name = os
    os_name = os[ 0...80 ] if ( os_name.size > 80 )
    organism = Organism.where(name: os_name ).take
    organism = Organism.create(name: os_name ) if organism.nil?
    # puts "organism: #{organism.name}"
    puts "#{entry.sequence_name}"
    
    # Find or create source.
    source = Source.where(name: "SwissProt").take
    source = Source.create( name: "SwissProt", table_name: "Biosequences", updated_at: Time::now )
    
    # Find or create gene.
    gene = load_gene( entry, organism.id )
    return if gene.nil?
    
    # Load diseases.
    load_diseases( entry, gene.id )
    
    # Find or create Biosequence entry.
    biosequence = Biosequence.where(organism_id: organism.id, gene_id: gene.id ).take
    
    aa_seq = entry.sequence_data
    aa_seq = aa_seq[ 0...4000 ] if aa_seq.size > 4000
    accession = get_accession( entry )
    if biosequence.nil?
      biosequence = Biosequence.create( accession: accession, source_id: source.id, organism_id: organism.id, gene_id: gene.id, name: entry.sequence_name, aa_sequence: aa_seq, updated_at: Time::now )
    else
      biosequence.update_attributes( accession: accession, aa_sequence: aa_seq, updated_at: Time::now )
    end  # if
    
    # Load protein structures.
    load_structures( entry, biosequence.id )
    
    # Load protein domains.
    load_domains( entry, biosequence.id, gene.id )
    
    # Load Gene Ontology annotation.
    load_go( entry, gene.id )
  end  # load_entry
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    swiss_iterator = SwissIterator.new( filename )
    swiss_iterator.open_file
    while ( swiss_iterator.is_end_of_file? == false )
      entry = swiss_iterator.next_entry
      if ! entry.nil?
        load_entry( entry )
      else
        puts "entry is nil"
      end  # if
    end  # while
    swiss_iterator.close_file
  end # load_data
    
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = SwissLoader.new
  if ARGV.length >= 1
    app.load_data( ARGV[0] )
  else
    app.load_data( "uniprot_sprot.dat" )
  end  # if
end  # main_method

main_method
