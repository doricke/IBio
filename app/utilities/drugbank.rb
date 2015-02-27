require 'httparty'
require 'nokogiri'
require 'saxerator'

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

################################################################################
def parse_drugbank

  # download_dir = '/Users/ne24918/Documents/miscProjects/drugbank/'
  # zip_name = 'drugbank.xml.zip'
  file_name = 'drugbank.xml'
  # source_file = 'http://www.drugbank.ca/system/downloads/current/drugbank.xml.zip'
  # output_file_name = 'parsed_drugbank.txt'


  # Dir.chdir(download_dir)
  #puts Dir.pwd

  #puts "downloading file"
  #File.open(zip_name, "wb") do |f|
  #  f.write HTTParty.get(source_file)
  #end

  # puts "extracting file"
  # `tar -xf #{zip_name} #{file_name}`

  f = File.open(file_name)
  parser = Saxerator.parser(f)
  f.close

  source = Source.where(name: 'DrugBank').take
  if source.nil?
    source = Source.create(name: 'DrugBank', table_name: 'Drug', updated_at: Time::now)
  else
    source.updated_at = Time::now
    source.save
  end  # if
  
  synonym_itype = Itype.where(name: 'Synonym', category: 'Drug').take
  synonym_itype = Itype.create(name: 'Synonym', category: 'Drug') if synonym_itype.nil?
  
  salt_itype = Itype.where(name: 'Salt', category: 'Drug').take
  salt_itype = Itype.create(name: 'Salt', category: 'Drug') if salt_itype.nil?

  # File.open(output_file_name, 'w') do |f|
    #7682 drugs, this will take ~2min to parse full file
    parser.for_tag(:drug).each_with_index do |drug, index|
      # f.write("#{index}\n")
      # f.write("#{drug['name']} \n")
      # f.write("drugbank-ids:\n")
      # f.write("\t#{drug['drugbank-id']} \n")
      # f.write("description:\n")
      # f.write("\t#{drug['description']} \n")
      drug_rec = Drug.where(name: drug['name']).take
      if drug_rec.nil?
        note = Note.where(comment: drug['description']).take
        note = Note.create(comment: drug['description'], table_name: 'Drug') if note.nil?
        drug_rec = Drug.create(note_id: note.id, name: drug['name]'])
      end  # if

      load_synonyms( drug, drug_rec, 'synonyms', 'synonym', source.id, synonym_itype.id )
      load_synonyms( drug, drug_rec, 'salts', 'salt', source.id, salt_itype.id)
      
      # drug_parse_hash_or_array(drug, 'targets', 'target', 'name', 'id', 'action')
      # drug_parse_hash_or_array(drug, 'synonyms', 'synonym')
      # drug_parse_hash_or_array(drug, 'salts', 'salt')

      pathways_parser(drug, drug_rec, source_id)
      # f.write("\n\n")
    end
  # end

  puts 'done'
end  # parse_drugbank

################################################################################
def load_synonyms(drug, drug_rec, plural, singular, source_id, itype_id)
  return if drug[plural].empty?
  drug[plural][singular].each do |synonym|
    synonym_rec = Synonym.where(table_name: 'Drug', record_id: drug_rec.id, synonym_name: synonym).take
    Synonym.create(source_id: source_id, itype_id: itype_id, table_name: 'Drug', record_id: drug_rec.id, synonym_name: synonym) if synonym_rec.nil?
  end  # do
end  # load_synonyms

################################################################################
def drug_parse_hash_or_array(drug, plural, singular, *fields)
  # file.write("#{plural}:\n")

  #if there are no items
  if drug[plural].empty?
    # file.write("\tNo #{plural}\n")
    return
  end

  #if there is nothing that follows in the fields
  if fields.empty?
    drug[plural][singular].kind_of?(Array) ?
      # file.write("\t#{drug[plural][singular].join(', ')}\n") :
      # file.write("\t#{drug[plural][singular]}\n")

  #if there are fields
  else

    if drug[plural][singular].kind_of?(Array)
      drug[plural][singular].each do |single|
        fields.each do |field|
          # file.write("\t#{single[field]}\n") unless single[field].nil?
        end
      end
    else
      fields.each do |field|
        # file.write("\t#{drug[plural][singular][field]}\n") unless drug[plural][singular][field].nil?
      end
    end

  end
end


################################################################################
def pathways_parser(drug, drug_rec, source_id)
  pathways = drug['pathways']
  return if pathways.nil?

  if pathways.kind_of?(Array)
    pathways.each_with_index do |pathway, index|
      drugs_and_enzymes(pathway, drug, drug_rec)
    end
  else
    drugs_and_enzymes(pathways, drug, drug_rec)
  end  # if
end  # pathways_parser

################################################################################
def drugs_and_enzymes(pathway, drug, drug_rec, source_id)

  pathway_rec = Pathway.where(name: pathway['name']).take
  pathway_rec = Pathway.create(name: pathway['name'], source_id: source_id, smpdb_id: pathway['smpdb-id']) if pathway_rec.nil?

  drug_reaction = DrugReaction.where(drug_id: drug_rec.id, pathway_id: pathway_rec.id)
  drug_reaction = DrugReaction.create(drug_id: drug_rec.id, pathway_id: pathway_rec.id, source_id: source_id) if drug_reaction.nil?

  enzymes = pathway['enzymes']
  # file.write("\t\tenzymes: ")
  uniprots = enzymes['uniprot-id']
  if uniprots.kind_of?(Array)
    uniprots.each do |uniprot|
      drug_sequence(uniprot, drug_rec, source_id)
    end  # do
    # file.write("#{uniprots.join(', ')}\n")
  else
    drug_sequence(uniprot, drug_rec, source_id)
    # file.write("#{uniprots}\n")
  end  # if

end  # drugs_and_enzymes

################################################################################
def drug_sequence( uniprot, drug_rec, source_id )
  biosequence = Biosequence.where(accession: uniprot).take
  return if biosequence.nil?
  
  drug_gene = DrugGene.where( drug_id: drug_rec.id, gene_id: biosequence.gene_id )
  drug_gene = DrugGene.create(drug_id: drug_rec.id, gene_id: biosequence.gene_id, source_id: source_id) if drug_gene.nil?
end  # drug_sequence

################################################################################
parse_drugbank
