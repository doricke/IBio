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

class PathwayLoader
  
  ###############################################################################
  def fit( value, len )
    return value if value.size <= len
    return value[0...len]
  end  # fit
  
  ###############################################################################
  def load_data( filename )
    puts "Loading file: #{filename}"
    
    tokens = filename.split( "/" )
    prename = tokens[2].split( "." )
    name = prename[0]
    puts "Pathway name: #{name}"
    pathway = Pathway.find_by_name(name)
    pathway = Pathway.create(name: name) if ! pathway
    
    from = Itype.find_by_name_and_category("From", "Reaction")
    from = Itype.create(name: "From", category: "Reaction") if ! from
    to = Itype.find_by_name_and_category("To", "Reaction")
    to = Itype.create(name: "To", category: "Reaction") if ! to
    
    info_file = InputFile.new(filename)
    info_file.open_file
    line = info_file.next_line()  # skip header line.
    rank = 1
    while ( info_file.is_end_of_file? == false )
      line = info_file.next_line()
      process_line( line, pathway.id, rank, from.id, to.id ) if ( info_file.is_end_of_file? == false )
      rank += 1
    end  # while
    info_file.close_file    
  end #load_infos
  
  ###############################################################################
  def process_line( line, pathway_id, rank, from_id, to_id )
    tokens = line.split( "\t" )
    sources = tokens[0].split( "," )
    results = tokens[1].split( "," )
    itype = Itype.find_by_name_and_category(tokens[2], "Reaction")
    itype = Itype.create(name: tokens[2], category: "Reaction") if ! itype
    control_itype_id = nil
    if ( tokens[4].size > 0 )
      control_itype = Itype.find_by_name(tokens[4])
      control_itype = Itype.create(name: tokens[4], category: "Control Type") if ! control_itype
      control_itype_id = control_itype.id
    end  # if
    
    reaction = Reaction.create(pathway_id: pathway_id, itype_id: itype.id, control_itype: control_itype_id, 
        from: fit(tokens[0], 80), to: fit(tokens[1], 80), control: fit(tokens[3], 80), rank: rank)
    
    # Source genes.
    sources.each do |source|
      gene = Gene.find_by_gene_symbol(source)
      GeneReaction.create(pathway_id: pathway_id, reaction_id: reaction.id, gene_id: gene.id, role_itype_id: from_id) if gene
    end  # do
    
    # To genes.
    results.each do |result|
      gene = Gene.find_by_gene_symbol(result)
      GeneReaction.create(pathway_id: pathway_id, reaction_id: reaction.id, gene_id: gene.id, role_itype_id: to_id) if gene
    end  # do
    
    # Drugs listed.
    if ( tokens[8].size > 0 )
      drugs = tokens[8].split( "," )
      drugs.each do |drug_name|
        drug = Drug.find_by_name(drug_name)
        drug = Drug.create(name: drug_name) if ! drug
        DrugReaction.create(drug_id: drug.id, pathway_id: pathway_id, reaction_id: reaction.id)
      end  # do
    end # if
    
  end # process line
  
end # class

###############################################################################

def main_method
  app = PathwayLoader.new
  if ARGV.length >= 1
    app.load_data( ARGV[0] )
  else
    app.load_data( "data/pathways/PA145011109-Atorvastatin_Lovastatin_Simvastatin_Pathway_Pharmacokinetics.tsv" )
  end  # if
end  # main_method

main_method
