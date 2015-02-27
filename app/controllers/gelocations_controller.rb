
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

class GelocationsController < ApplicationController
  before_action :set_gelocation, only: [:show, :edit, :update, :destroy]

  # GET /gelocations
  # GET /gelocations.json
  def index
    @gelocations = Gelocation.where(individual_id: session['individual_id']).to_a
  end

  # GET /gelocations/1
  # GET /gelocations/1.json
  def show
  end

  # GET /gelocations/new
  def new
    @gelocation = Gelocation.new
  end

  # GET /gelocations/1/edit
  def edit
  end

  # POST /gelocations
  # POST /gelocations.json
  def create
    @gelocation = Gelocation.new(gelocation_params)

    respond_to do |format|
      if @gelocation.save
        format.html { redirect_to @gelocation, notice: 'Gelocation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @gelocation }
      else
        format.html { render action: 'new' }
        format.json { render json: @gelocation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gelocations/1
  # PATCH/PUT /gelocations/1.json
  def update
    respond_to do |format|
      if @gelocation.update(gelocation_params)
        format.html { redirect_to @gelocation, notice: 'Gelocation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gelocation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gelocations/1
  # DELETE /gelocations/1.json
  def destroy
    @gelocation.destroy
    respond_to do |format|
      format.html { redirect_to gelocations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gelocation
      @gelocation = Gelocation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gelocation_params
      params.require(:gelocation).permit(:individual_id, :logitude, :latitude, :timepoint)
    end
end
