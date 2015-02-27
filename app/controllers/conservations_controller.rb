
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

class ConservationsController < ApplicationController
  before_action :set_conservation, only: [:show, :edit, :update, :destroy]

  # GET /conservations
  # GET /conservations.json
  def index
    @conservations = Conservation.all
  end

  # GET /conservations/1
  # GET /conservations/1.json
  def show
  end

  # GET /conservations/new
  def new
    @conservation = Conservation.new
  end

  # GET /conservations/1/edit
  def edit
  end

  # POST /conservations
  # POST /conservations.json
  def create
    @conservation = Conservation.new(conservation_params)

    respond_to do |format|
      if @conservation.save
        format.html { redirect_to @conservation, notice: 'Conservation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @conservation }
      else
        format.html { render action: 'new' }
        format.json { render json: @conservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conservations/1
  # PATCH/PUT /conservations/1.json
  def update
    respond_to do |format|
      if @conservation.update(conservation_params)
        format.html { redirect_to @conservation, notice: 'Conservation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @conservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conservations/1
  # DELETE /conservations/1.json
  def destroy
    @conservation.destroy
    respond_to do |format|
      format.html { redirect_to conservations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conservation
      @conservation = Conservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conservation_params
      params.require(:conservation).permit(:biosequence_id, :position, :level)
    end
end
