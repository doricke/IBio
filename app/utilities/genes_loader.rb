require 'input_file.rb'

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

class GenesLoader
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    organism_id = get_organism()
    
    info_file = InputFile.new(filename)
    info_file.open_file
    # contents = info_file.read_file
    line = info_file.next_line()
    while ( info_file.is_end_of_file? == false )
      line = info_file.next_line()
      process_line( line, organism_id ) if ( info_file.is_end_of_file? == false )
    end  # while
    info_file.close_file
    
    # load_contents( contents )
  end #load_infos
  
  ###############################################################################
  def get_organism()
    # human = Organism.where(name: "Human").first_or_create
    #    .update_attributes(name: "Human", genus: "Homo", species: "sapiens", 
    #    taxonomy: "Eukaryota; Metazoa; Chordata; Craniata; Vertebrata; Euteleostomi; Mammalia; Eutheria; Euarchontoglires; Primates; Haplorrhini; Catarrhini; Hominidae; Homo.")
    Organism.where(name: "Human").first_or_create
        .update_attributes(name: "Human", taxonomy: "Eukaryota; Metazoa; Chordata; Craniata; Vertebrata; Euteleostomi; Mammalia; Eutheria; Euarchontoglires; Primates; Haplorrhini; Catarrhini; Hominidae; Homo.")
    human = Organism.find_by_name( "Human" )
    return human.id
  end  # get_organism
  
  ###############################################################################
  def load_contents( contents )
    lines = contents.split( "\n" )
    for i in 1...lines.length do
      process_line( lines[i].delete( '"' ) )
    end  # for
  end  # load_contents
    
  ###############################################################################
  def fit( value, len )
    return value if value.size <= len
    return value[0...len]
  end  # fit
 
  ###############################################################################
  def process_line( line, organism_id )
    tokens = line.split( "\t" )
    
    puts "#{tokens[3]}"
    gene = Gene.find_by_ncbi_gene_id(tokens[1])
    dosing = false
    dosing = true if tokens[10] == "TRUE"
    if gene
      # gene.organism_id = organism_id
      gene.name = tokens[3]
      gene.pharm_gkb_id = tokens[0]
      gene.cpic_dosing = dosing
      gene.save
    else
      # gene = Gene.create(organism_id: organism_id, name: tokens[3], ncbi_gene_id: tokens[1], gene_symbol: tokens[4], pharm_gkb_id: tokens[0], description: tokens[3], synonyms: tokens[6], chromosome: tokens[11][3..-1], chromosome_start: tokens[12].to_i, chromosome_end: tokens[13].to_i, updated_at:  Time::now)
      gene = Gene.create(name: fit(tokens[3], 200), ncbi_gene_id: tokens[1], gene_symbol: fit(tokens[4], 40), pharm_gkb_id: fit(tokens[0], 16), description: fit(tokens[3], 240), synonyms: fit(tokens[6], 120), chromosome: tokens[11][3..-1], chromosome_start: tokens[12].to_i, chromosome_end: tokens[13].to_i, updated_at: Time::now)
    end  # if
    
  end #process line
  
end #class

###############################################################################

def main_method
  app = GenesLoader.new
  app.load_data( "data/genes.tsv" )
end  # main_method

main_method
