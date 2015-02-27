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

class GeneInfoLoader
  
  ###############################################################################
  def fit( value, len )
    return value if value.size <= len
    return value[0...len]
  end  # fit
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    organism_id = get_organism()
    
    info_file = InputFile.new(filename)
    info_file.open_file
    # contents = info_file.read_file
    while ( info_file.is_end_of_file? == false )
      line = info_file.next_line()
      process_line( line, organism_id ) if ( info_file.is_end_of_file? == false )
    end  # while
    info_file.close_file
    
    # load_contents( contents )
  end #load_infos
  
  ###############################################################################
  def get_organism()
    Organism.where(name: "Human").first_or_create
        .update_attributes(name: "Human", genus: "Homo", species: "sapiens", 
        taxonomy: "Eukaryota; Metazoa; Chordata; Craniata; Vertebrata; Euteleostomi; Mammalia; Eutheria; Euarchontoglires; Primates; Haplorrhini; Catarrhini; Hominidae; Homo.")
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
  def process_line( line, organism_id )
    tokens = line.split( "\t" )
    
    puts "#{tokens[2]}"
    
    # Gene.where(ncbi_gene_id: tokens[1]).first_or_create.update_attributes(
    #     organism_id: organism_id, name: fit(tokens[2], 200), ncbi_gene_id: fit(tokens[1], 12), 
    #     gene_symbol: fit(tokens[2], 40), synonyms: fit(tokens[3], 120), chromosome: fit(tokens[6], 2), 
    #     description: fit(tokens[8], 240) ) if tokens[9] != "pseudo"
    
    Gene.where(ncbi_gene_id: tokens[1]).first_or_create.update_attributes(
        name: fit(tokens[2], 200), ncbi_gene_id: fit(tokens[1], 12), 
        gene_symbol: fit(tokens[2], 40), synonyms: fit(tokens[3], 120), chromosome: fit(tokens[6], 2), 
        description: fit(tokens[8], 240) ) if tokens[9] != "pseudo"
    
  end #process line
  
end #class

###############################################################################

def main_method
  app = GeneInfoLoader.new
  app.load_data( "data/gene_info.hs" )
end  # main_method

main_method
