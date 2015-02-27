
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

class AllelesController < ApplicationController
  before_action :set_allele, only: [:show, :edit, :update, :destroy]

  # GET /alleles
  # GET /alleles.json
  def index
    @alleles = Allele.all
  end

  # GET /alleles/1
  # GET /alleles/1.json
  def show
  end

  # GET /alleles/new
  def new
    @allele = Allele.new
  end

  # GET /alleles/1/edit
  def edit
  end

  # POST /alleles
  # POST /alleles.json
  def create
    @allele = Allele.new(allele_params)

    respond_to do |format|
      if @allele.save
        format.html { redirect_to @allele, notice: 'Allele was successfully created.' }
        format.json { render action: 'show', status: :created, location: @allele }
      else
        format.html { render action: 'new' }
        format.json { render json: @allele.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alleles/1
  # PATCH/PUT /alleles/1.json
  def update
    respond_to do |format|
      if @allele.update(allele_params)
        format.html { redirect_to @allele, notice: 'Allele was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @allele.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alleles/1
  # DELETE /alleles/1.json
  def destroy
    @allele.destroy
    respond_to do |format|
      format.html { redirect_to alleles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_allele
      @allele = Allele.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def allele_params
      params.require(:allele).permit(:locus_id, :ethnic_id, :name, :seq, :regular_expression, :allele_frequency)
    end
end
