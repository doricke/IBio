################################################################################
# Copyright (C) 2015  Darrell O. Ricke, PhD
# Author::    	Darrell O. Ricke, Ph.D.  (mailto: Darrell.Ricke@ll.mit.edu)
# Copyright:: 	Copyright (c) 2014 MIT Lincoln Laboratory
# License::   	GNU GPL license  (http://www.gnu.org/licenses/gpl.html)
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

require 'input_file.rb'
require 'tools.rb'

###############################################################################
class SnpsLoader

$snps = {}    # target SNPs; key - snp name; value - snp record
$snp_type = Itype.find_by_name("SNP")
  
###############################################################################
def create_experiment( individual_id, instrument_id, itype_id, attachment_id, name )
  experiment = Experiment.where( attachment_id: attachment_id ).take
  return experiment if ! experiment.nil?
  return Experiment.create( individual_id: individual_id, instrument_id: instrument_id, itype_id: itype_id, attachment_id: attachment_id, name: name, created_at: Time::now )
end  # create_experiment
  
###############################################################################
def load_contents( contents, guid2, individual_id, instrument_id, itype_id, name, attachment_id )
  puts "#### SNP loader called for #{guid2} !!!!"
  load_snps
  
  ActiveRecord::Base.transaction do
    experiment = create_experiment( individual_id, instrument_id, itype_id, attachment_id, name )
  
    lines = contents.split( "\n" )
    for i in 1...lines.length do
      process_line( lines[i], guid2, experiment.id ) if (lines[i][0] != '#')
    end  # for
  end  # do
end  # load_contents

###############################################################################
def load_snp_file( filename )
  user_id = setup_user( filename )
  
  snp_file = InputFile.new( filename )
  snp_file.open_file
  while ( ! snp_file.is_end_of_file? )
    line = snp_file.next_line().chomp.delete("\r")
    parse_line( line.delete( '"' ), user_id ) if line.length > 0
  end  # while
  snp_file.close_file
end  # load_snp_file

###############################################################################
def load_snps
  snps = Locu.all
  snps.each do |snp|
    $snps[snp.name] = snp
  end  # do
end  # load_snps
  
###############################################################################
def new_snp( name, chromosome, position )
  snp = Locu.create(itype_id: $snp_type.id, name: name, chromosome: chromosome, position: position.to_i )
  $snps[ name ] = snp
  return snp
end  # new_snp

###############################################################################
def process_line( line, guid2, experiment_id )
  return if line[0] == '#'    # Comment
  tokens = line.split( "\t" )
  tokens = line.split( "," ) if tokens.size <= 1

  name = tokens[0]
  return if name == "Name"
  
  snp = $snps[ name ]
  snp = new_snp( tokens[0], tokens[1], tokens[2] ) if snp.nil?
  
  AlleleCall.create( guid2: guid2, experiment_id: experiment_id, locus_id: snp.id, alleles: tokens[3][0..1] )
end  # process_line


###############################################################################

end  # SnpsLoader

