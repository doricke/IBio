
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

class PathwaysController < ApplicationController
  before_action :set_pathway, only: [:show, :edit, :update, :destroy]

  # GET /pathways
  # GET /pathways.json
  def index
    @pathways = Pathway.all
  end  # index

  # GET /pathways/1
  # GET /pathways/1.json
  def show
    @reactions = Reaction.where(pathway_id: @pathway.id).order(:rank).to_a
    @itypes_hash = Tools::to_hash(Itype.all)
    @drug_reactions = DrugReaction.by_reaction(@pathway.id)
    @gene_reactions = GeneReaction.by_reaction(@pathway.id)
  end  # show

  # GET /pathways/new
  def new
    @pathway = Pathway.new
  end  # new

  # GET /pathways/1/edit
  def edit
  end

  # POST /pathways
  # POST /pathways.json
  def create
    @pathway = Pathway.new(pathway_params)

    respond_to do |format|
      if @pathway.save
        format.html { redirect_to @pathway, notice: 'Pathway was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pathway }
      else
        format.html { render action: 'new' }
        format.json { render json: @pathway.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pathways/1
  # PATCH/PUT /pathways/1.json
  def update
    respond_to do |format|
      if @pathway.update(pathway_params)
        format.html { redirect_to @pathway, notice: 'Pathway was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pathway.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pathways/1
  # DELETE /pathways/1.json
  def destroy
    @pathway.destroy
    respond_to do |format|
      format.html { redirect_to pathways_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pathway
      @pathway = Pathway.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pathway_params
      params.require(:pathway).permit(:name)
    end
end
