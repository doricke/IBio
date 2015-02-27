
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

class GeneReaction < ActiveRecord::Base

  def self.by_gene
    gene_reactions = GeneReaction.all
    gene2reactions = {}
    gene_reactions.each do |gene_reaction|
      if gene2reactions[ gene_reaction.gene_id ].nil?
        gene2reactions[ gene_reaction.gene_id ] = [gene_reaction]  # has of array elements
      else
        gene2reactions[ gene_reaction.gene_id ] << gene_reaction
      end  # if
    end  # do
    return gene2reactions
  end  # method by_gene

  def self.by_reaction(pathway_id)
    gene2reactions = {}
    gene_reactions = GeneReaction.find_all_by_pathway_id(pathway_id)
    gene_reactions.each do |gene_reaction|
      if ( gene2reactions[ gene_reaction.reaction_id].nil? )
        gene2reactions[ gene_reaction.reaction_id ] = [gene_reaction]
      else
        gene2reactions[ gene_reaction.reaction_id ] << gene_reaction
      end  # if
    end  # do
    return gene2reactions
  end  # method by_reaction

end  # class
