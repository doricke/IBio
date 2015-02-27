
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

class Locu < ActiveRecord::Base

  def self.by_disease
    all_loci = Locu.where("disease_id is not null")
    disease2loci = {}
    all_loci.each do |locus|
      if disease2loci[ locus.disease_id ].nil?
        disease2loci[ locus.disease_id ] = [locus]
      else
        disease2loci[ locus.disease_id ] << locus
      end  # if
    end  # do
    return disease2loci
  end  # method by_disease

  def self.by_gene
    all_loci = Locu.where("gene_id is not null")
    gene2loci = {}
    all_loci.each do |locus|
      if gene2loci[ locus.gene_id ].nil?
        gene2loci[ locus.gene_id ] = [locus]  # hash of array elements
      else
        gene2loci[ locus.gene_id ] << locus
      end  # if
    end  # do
    return gene2loci
  end  # method by_gene

end  # class
