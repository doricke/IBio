
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

class StructureSequencesController < ApplicationController
  before_action :set_structure_sequence, only: [:show, :edit, :update, :destroy]

  # GET /structure_sequences
  # GET /structure_sequences.json
  def index
    @structure_sequences = StructureSequence.all
  end

  # GET /structure_sequences/1
  # GET /structure_sequences/1.json
  def show
  end

  # GET /structure_sequences/new
  def new
    @structure_sequence = StructureSequence.new
  end

  # GET /structure_sequences/1/edit
  def edit
  end

  # POST /structure_sequences
  # POST /structure_sequences.json
  def create
    @structure_sequence = StructureSequence.new(structure_sequence_params)

    respond_to do |format|
      if @structure_sequence.save
        format.html { redirect_to @structure_sequence, notice: 'Structure sequence was successfully created.' }
        format.json { render action: 'show', status: :created, location: @structure_sequence }
      else
        format.html { render action: 'new' }
        format.json { render json: @structure_sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /structure_sequences/1
  # PATCH/PUT /structure_sequences/1.json
  def update
    respond_to do |format|
      if @structure_sequence.update(structure_sequence_params)
        format.html { redirect_to @structure_sequence, notice: 'Structure sequence was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @structure_sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /structure_sequences/1
  # DELETE /structure_sequences/1.json
  def destroy
    @structure_sequence.destroy
    respond_to do |format|
      format.html { redirect_to structure_sequences_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_structure_sequence
      @structure_sequence = StructureSequence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def structure_sequence_params
      params.require(:structure_sequence).permit(:structure_id, :biosequence_id, :chain, :resolution, :aa_start, :aa_end)
    end
end
