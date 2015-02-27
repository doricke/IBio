
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

class AlleleCallsController < ApplicationController
  before_action :set_allele_call, only: [:show, :edit, :update, :destroy]

  # GET /allele_calls
  # GET /allele_calls.json
  def index
    @allele_calls = AlleleCall.where(guid2: session['guid2']).to_a
  end

  # GET /allele_calls/1
  # GET /allele_calls/1.json
  def show
  end

  # GET /allele_calls/new
  def new
    @allele_call = AlleleCall.new
  end

  # GET /allele_calls/1/edit
  def edit
  end

  # POST /allele_calls
  # POST /allele_calls.json
  def create
    @allele_call = AlleleCall.new(allele_call_params)

    respond_to do |format|
      if @allele_call.save
        format.html { redirect_to @allele_call, notice: 'Allele call was successfully created.' }
        format.json { render action: 'show', status: :created, location: @allele_call }
      else
        format.html { render action: 'new' }
        format.json { render json: @allele_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /allele_calls/1
  # PATCH/PUT /allele_calls/1.json
  def update
    respond_to do |format|
      if @allele_call.update(allele_call_params)
        format.html { redirect_to @allele_call, notice: 'Allele call was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @allele_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /allele_calls/1
  # DELETE /allele_calls/1.json
  def destroy
    @allele_call.destroy
    respond_to do |format|
      format.html { redirect_to allele_calls_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_allele_call
      @allele_call = AlleleCall.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def allele_call_params
      params.require(:allele_call).permit(:locus_id, :experiment_id, :alleles, :guid2)
    end
end
