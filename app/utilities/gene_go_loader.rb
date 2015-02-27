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

class GeneGoLoader
  
  ###############################################################################
  def fit( value, len )
    return value if value.size <= len
    return value[0...len]
  end  # fit
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    itypes = Itype.find_all_by_category( "Gene Ontology" )
    itypes_hash = {}
    itypes.each do |itype|
      itypes_hash[itype.name] = itype
    end  # do
    
    genes = Gene.all
    genes_hash = {}
    genes.each do |gene|
      genes_hash[gene.ncbi_gene_id] = gene
    end  # do
    
    go_file = InputFile.new(filename)
    go_file.open_file
    while ( go_file.is_end_of_file? == false )
      line = go_file.next_line().chomp
      process_line( line, genes_hash, itypes_hash ) if ( go_file.is_end_of_file? == false )
    end  # while
    go_file.close_file
    
  end #load_data
  
  ###############################################################################
  def process_line( line, genes_hash, itypes_hash )
    tokens = line.split( "\t" )
    gene = genes_hash[ tokens[1] ]
    puts "--> #{line}"
    return if gene.nil?
    
    itype = itypes_hash[ tokens[7] ]
    pubmed = tokens[6]
    pubmed = "" if tokens[6] == "-"
    
    term = fit(tokens[5], 80)
    Go.where(gene_id: gene.id, itype_id: itype.id, term: term).first_or_create.update_attributes(gene_id: gene.id, itype_id: itype.id, term: term, pubmed: fit(pubmed, 10))    
  end #process line
  
end #class

###############################################################################

def main_method
  app = GeneGoLoader.new
  app.load_data( "data/gene2go.hs" )
end  # main_method

main_method
