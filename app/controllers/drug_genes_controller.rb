
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

class DrugGenesController < ApplicationController
  before_action :set_drug_gene, only: [:show, :edit, :update, :destroy]

  # GET /drug_genes
  # GET /drug_genes.json
  def index
    @drug_genes = DrugGene.all
  end

  # GET /drug_genes/1
  # GET /drug_genes/1.json
  def show
  end

  # GET /drug_genes/new
  def new
    @drug_gene = DrugGene.new
  end

  # GET /drug_genes/1/edit
  def edit
  end

  # POST /drug_genes
  # POST /drug_genes.json
  def create
    @drug_gene = DrugGene.new(drug_gene_params)

    respond_to do |format|
      if @drug_gene.save
        format.html { redirect_to @drug_gene, notice: 'Drug gene was successfully created.' }
        format.json { render action: 'show', status: :created, location: @drug_gene }
      else
        format.html { render action: 'new' }
        format.json { render json: @drug_gene.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drug_genes/1
  # PATCH/PUT /drug_genes/1.json
  def update
    respond_to do |format|
      if @drug_gene.update(drug_gene_params)
        format.html { redirect_to @drug_gene, notice: 'Drug gene was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @drug_gene.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drug_genes/1
  # DELETE /drug_genes/1.json
  def destroy
    @drug_gene.destroy
    respond_to do |format|
      format.html { redirect_to drug_genes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_drug_gene
      @drug_gene = DrugGene.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def drug_gene_params
      params.require(:drug_gene).permit(:drug_id, :gene_id, :cpic_dosing, :pharm_gbk_id, :interaction, :source, :testing_level)
    end
end
