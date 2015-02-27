
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

class SolventsController < ApplicationController
  before_action :set_solvent, only: [:show, :edit, :update, :destroy]

  # GET /solvents
  # GET /solvents.json
  def index
    @solvents = Solvent.all
  end

  # GET /solvents/1
  # GET /solvents/1.json
  def show
  end

  # GET /solvents/new
  def new
    @solvent = Solvent.new
  end

  # GET /solvents/1/edit
  def edit
  end

  # POST /solvents
  # POST /solvents.json
  def create
    @solvent = Solvent.new(solvent_params)

    respond_to do |format|
      if @solvent.save
        format.html { redirect_to @solvent, notice: 'Solvent was successfully created.' }
        format.json { render action: 'show', status: :created, location: @solvent }
      else
        format.html { render action: 'new' }
        format.json { render json: @solvent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /solvents/1
  # PATCH/PUT /solvents/1.json
  def update
    respond_to do |format|
      if @solvent.update(solvent_params)
        format.html { redirect_to @solvent, notice: 'Solvent was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @solvent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solvents/1
  # DELETE /solvents/1.json
  def destroy
    @solvent.destroy
    respond_to do |format|
      format.html { redirect_to solvents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solvent
      @solvent = Solvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def solvent_params
      params.require(:solvent).permit(:biosequence_id, :position, :accessibility)
    end
end
