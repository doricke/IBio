require 'input_file.rb'
require 'vcf.rb'

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

class VcfLoader
  
  # Known genes
  attr_accessor :genes
  
  attr_accessor :rna_map
  
###############################################################################
def initialize
  @genes = {}
  @rna_map = {}
end  # initialize

###############################################################################
  def load_map( filename )
    map_file = InputFile.new( filename )
    map_file.open_file
    l = map_file.next_line()  # Skip header line
    
    # Load in the protein to RNA map
    while ( map_file.is_end_of_file? == false )
      l = map_file.next_line()
      if ( map_file.is_end_of_file? == false )
        tokens = l.split( "," )
        if ( tokens[1].to_i < 20 )
          @rna_map[ tokens[4] ] = tokens[0]
        end  # if
      end  # if
    end  # while
  end  # load_map
  
###############################################################################
  def load_data( filename, data_entry_id, instrument_name )
    puts "Loading file: #{filename}, instrument: #{instrument_name}"
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    puts "Individual found"
    
    name = instrument_name
    name = "Ion Torrent PGM" if (instrument_name == "PGM") || (instrument_name == "pgm")
    name = "Ion Torrent Proton" if (instrument_name == "Proton")
    instrument = Instrument.where( name: name ).take
    return if instrument.nil?
    puts "Instrument found"
    
    itype = Itype.where( name: instrument_name, category: 'attachment' ).take
    itype = Itype.create( name: instrument_name, category: 'attachment' ) if itype.nil?


    vcf_file = InputFile.new(filename)
    vcf_file.open_file
    contents = vcf_file.read_file
    vcf_file.close_file

    attachment = Attachment.find_by_individual_id_and_name( individual.id, filename )
    if attachment.nil?
      attachment = Attachment.create(individual_id: individual.id, instrument_id: instrument.id,
          itype_id: itype.id, name: filename, created_at: Time::now, file_text: contents, content_type: 'text/plain', is_parsed: true)
    else
      attachment.update_attributes( created_at: Time::now, file_text: contents, is_parsed: true )
    end  # if
    
    load_genes
    
    load_contents( contents, individual, instrument.id )
  end #load_vcfs
  
  
###############################################################################
  def load_contents( contents, individual, instrument_id )
    puts "#### VcfLoader called!!!!"
    lines = contents.split( "\n" )
    for i in 0...lines.length do
      process_line( lines[i], individual, instrument_id )
    end  # for
  end  # load_contents
    
###############################################################################
def load_genes
  organism = Organism.where(name: "Human").take
  genes = Gene.where(organism_id: organism.id).to_a
  genes.each do |gene|
    @genes[ gene.name ] = gene
    @genes[ gene.gene_symbol ] = gene
  end  # do
end  # load_genes

###############################################################################
  def process_line( line, individual, instrument_id )
    return if line[0] == "#"
    variant = Vcf.new( line )
    variant.parse
    # puts "#{variant.to_string}"  
    variant.snap
    load_variant( variant, individual, instrument_id )
  end  # process_line
  
###############################################################################
  def load_variant( variant, individual, instrument_id )
    targets = {}
    variant.eff.each do |eff|
      details = eff.delete( ")" ).gsub( "(", "|" ).split( "|")
      gene_name = details[6]
      gene = @genes[ gene_name ]
      rna_name = details[9]
      puts "rna name: #{rna_name}"
      
      if ! gene.nil?
        biosequence = Biosequence.where(gene_id: gene.id).take
       
        if ! biosequence.nil?
          mutation = details[4]
          codon = mutation[1..-1].to_i
          if (targets[ gene_name ].nil?) && (! @rna_map[ details[9] ].nil? )
            if (details[2] == "MISSENSE") || (details[2] == "NONSENSE") || (details[2] == "SILENT") || (details[2] == "FRAME_SHIFT")
              puts "...#{gene_name} #{details[2]} #{mutation} #{codon}"
              targets[ gene_name ] = gene
              vari = Variant.where(biosequence_id: biosequence.id, instrument_id: instrument_id, guid2: individual.guid2, sequence_start: codon ).first_or_create.
              update_attributes(instrument_id: instrument_id,
                                biosequence_id: biosequence.id,
                                guid2: individual.guid2,
                                sequence_type: 'aa',
                                mutation: mutation,
                                mutation_type: details[2].downcase,
                                quality: variant.qual,
                                sequence_start: codon,
                                sequence_end: codon + variant.ref.size - 1,
                                dp4: variant.info_map[ 'DP4' ],
                                ref: variant.ref,
                                alt: variant.alt,
                                is_public: false)
            end  # if
          # else
            # puts "...#{details.join('|')}"
          end  # if
        else
          puts "  no sequence found for gene: #{gene_name}"
        end  # if
      else
        puts "  gene #{gene_name} not found"
      end  # if
    end  # do
  end  # load_variant

###############################################################################
      
end # class
    
###############################################################################
def main_method
  app = VcfLoader.new
  if ARGV.length >= 3
    app.load_map( "rna_protein_map.csv" )
    app.load_data( ARGV[0], ARGV[1].delete( '"' ), ARGV[2].delete( '"') )
  end  # if
end  # main_method
    
main_method
