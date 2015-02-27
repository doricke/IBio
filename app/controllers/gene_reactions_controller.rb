
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

class GeneReactionsController < ApplicationController
  before_action :set_gene_reaction, only: [:show, :edit, :update, :destroy]

  # GET /gene_reactions
  # GET /gene_reactions.json
  def index
    @gene_reactions = GeneReaction.all
  end

  # GET /gene_reactions/1
  # GET /gene_reactions/1.json
  def show
  end

  # GET /gene_reactions/new
  def new
    @gene_reaction = GeneReaction.new
  end

  # GET /gene_reactions/1/edit
  def edit
  end

  # POST /gene_reactions
  # POST /gene_reactions.json
  def create
    @gene_reaction = GeneReaction.new(gene_reaction_params)

    respond_to do |format|
      if @gene_reaction.save
        format.html { redirect_to @gene_reaction, notice: 'Gene reaction was successfully created.' }
        format.json { render action: 'show', status: :created, location: @gene_reaction }
      else
        format.html { render action: 'new' }
        format.json { render json: @gene_reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gene_reactions/1
  # PATCH/PUT /gene_reactions/1.json
  def update
    respond_to do |format|
      if @gene_reaction.update(gene_reaction_params)
        format.html { redirect_to @gene_reaction, notice: 'Gene reaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gene_reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gene_reactions/1
  # DELETE /gene_reactions/1.json
  def destroy
    @gene_reaction.destroy
    respond_to do |format|
      format.html { redirect_to gene_reactions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gene_reaction
      @gene_reaction = GeneReaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gene_reaction_params
      params.require(:gene_reaction).permit(:pathway_id, :reaction_id, :gene_id, :role_itype_id)
    end
end
