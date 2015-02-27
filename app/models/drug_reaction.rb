
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

class DrugReaction < ActiveRecord::Base
  has_many :drug
  has_many :pathway
  has_many :reaction
  
  def self.by_reaction(pathway_id)
    reactions = {}
    drug_reactions = DrugReaction.find_all_by_pathway_id(pathway_id)
    drug_reactions.each do |drug_reaction|
      reactions[ drug_reaction.reaction_id ] = drug_reaction
    end  # do
    return reactions
  end  # method by_reaction

end  # class DrugReaction
