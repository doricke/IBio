
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

class DiseaseGenesController < ApplicationController
  before_action :set_disease_gene, only: [:show, :edit, :update, :destroy]

  # GET /disease_genes
  # GET /disease_genes.json
  def index
    @disease_genes = DiseaseGene.all.to_a
    @genes_hash = Tools::to_hash(Gene.all.select('id,gene_symbol,name'))
    @diseases_hash = Tools::to_hash(Disease.all.select('id,mim_id,name'))
  end  # index

  # GET /disease_genes/1
  # GET /disease_genes/1.json
  def show
  end

  # GET /disease_genes/new
  def new
    @disease_gene = DiseaseGene.new
  end

  # GET /disease_genes/1/edit
  def edit
  end

  # POST /disease_genes
  # POST /disease_genes.json
  def create
    @disease_gene = DiseaseGene.new(disease_gene_params)

    respond_to do |format|
      if @disease_gene.save
        format.html { redirect_to @disease_gene, notice: 'Disease gene was successfully created.' }
        format.json { render action: 'show', status: :created, location: @disease_gene }
      else
        format.html { render action: 'new' }
        format.json { render json: @disease_gene.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disease_genes/1
  # PATCH/PUT /disease_genes/1.json
  def update
    respond_to do |format|
      if @disease_gene.update(disease_gene_params)
        format.html { redirect_to @disease_gene, notice: 'Disease gene was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @disease_gene.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disease_genes/1
  # DELETE /disease_genes/1.json
  def destroy
    @disease_gene.destroy
    respond_to do |format|
      format.html { redirect_to disease_genes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disease_gene
      @disease_gene = DiseaseGene.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def disease_gene_params
      params.require(:disease_gene).permit(:disease_id, :gene_id)
    end
end
