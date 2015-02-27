
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

class GenesController < ApplicationController
  before_action :set_gene, only: [:show, :edit, :update, :destroy]

  # GET /genes
  # GET /genes.json
  def index
    @genes = Gene.all(:select => 'id,name,gene_symbol,ncbi_gene_id')
    # @interactions = Interaction.by_gene
    @loci = Locu.by_gene
    @gene_reactions = GeneReaction.by_gene
    @pathways_hash = Tools::to_hash(Pathway.all)
  end  # index

  # GET /genes/1
  # GET /genes/1.json
  def show
    @disease_genes = DiseaseGene.where(gene_id: @gene.id).to_a
    @biosequences = Biosequence.where(gene_id: @gene.id).to_a
  end  # show

  # GET /genes/new
  def new
    @gene = Gene.new
  end  # new

  # GET /genes/1/edit
  def edit
  end

  # POST /genes
  # POST /genes.json
  def create
    @gene = Gene.new(gene_params)

    respond_to do |format|
      if @gene.save
        format.html { redirect_to @gene, notice: 'Gene was successfully created.' }
        format.json { render action: 'show', status: :created, location: @gene }
      else
        format.html { render action: 'new' }
        format.json { render json: @gene.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /genes/1
  # PATCH/PUT /genes/1.json
  def update
    respond_to do |format|
      if @gene.update(gene_params)
        format.html { redirect_to @gene, notice: 'Gene was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gene.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /genes/1
  # DELETE /genes/1.json
  def destroy
    @gene.destroy
    respond_to do |format|
      format.html { redirect_to genes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gene
      @gene = Gene.find(params[:id])
    end  # set_gene

    # Never trust parameters from the scary internet, only allow the white list through.
    def gene_params
      params.require(:gene).permit(:organism_id, :note_id, :name, :gene_symbol, :ncbi_gene_id, :description, :synonyms, :chromosome, :chromosome_start, :chromosome_end, :updated_at)
    end  # gene_params

end  # class
