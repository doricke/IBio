
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

class LocusController < ApplicationController
  before_action :set_locu, only: [:show, :edit, :update, :destroy]
  autocomplete :locu, :name, full: true, limit: 10

  # GET /locus
  # GET /locus.json
  def index
    @locus = Locu.new
  end  # index

  # GET /locus/1
  # GET /locus/1.json
  def show
    @itype = Itype.find(@locus.itype_id) if ! @locus.itype_id.nil?
    @gene = Gene.find(@locus.gene_id) if ! @locus.gene_id.nil?
    @disease = Disease.find(@locus.disease_id) if ! @locus.disease_id.nil?
    @allele_call = AlleleCall.where(guid2: session[:guid2], locus_id: @locus.id).take
  end  # show

  # GET /locus/new
  def new
    @locus = Locu.new
    @itypes = Itype.where(category: 'locus').order(:name).to_a
  end  # new

  # GET /locus/1/edit
  def edit
    @itypes = Itype.where(category: 'locus').order(:name).to_a
  end  # edit

  # POST /locus
  # POST /locus.json
  def create
    @locus = Locu.new(locu_params)

    respond_to do |format|
      if @locus.save
        format.html { redirect_to @locus, notice: 'Locu was successfully created.' }
        format.json { render action: 'show', status: :created, location: @locus }
      else
        @itypes = Itype.where(category: 'locus').order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @locus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locus/1
  # PATCH/PUT /locus/1.json
  def update
    respond_to do |format|
      if @locus.update(locu_params)
        format.html { redirect_to @locus, notice: 'Locu was successfully updated.' }
        format.json { head :no_content }
      else
        @itypes = Itype.where(category: 'locus').order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @locus.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locus/1
  # DELETE /locus/1.json
  def destroy
    @locus.destroy
    respond_to do |format|
      format.html { redirect_to locus_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_locu
      @locus = Locu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def locu_params
      params.require(:locu).permit(:disease_id, :gene_id, :itype_id, :name, :chromosome, :position)
    end
end
