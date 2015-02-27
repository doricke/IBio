
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

class AlignsController < ApplicationController
  before_action :set_align, only: [:show, :edit, :update, :destroy]

  # GET /aligns
  # GET /aligns.json
  def index
    @aligns = Align.where(true).to_a
  end

  # GET /aligns/1
  # GET /aligns/1.json
  def show
  end

  # GET /aligns/new
  def new
    @align = Align.new
  end

  # GET /aligns/1/edit
  def edit
  end

  # POST /aligns
  # POST /aligns.json
  def create
    @align = Align.new(align_params)

    respond_to do |format|
      if @align.save
        format.html { redirect_to @align, notice: 'Align was successfully created.' }
        format.json { render action: 'show', status: :created, location: @align }
      else
        format.html { render action: 'new' }
        format.json { render json: @align.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aligns/1
  # PATCH/PUT /aligns/1.json
  def update
    respond_to do |format|
      if @align.update(align_params)
        format.html { redirect_to @align, notice: 'Align was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @align.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aligns/1
  # DELETE /aligns/1.json
  def destroy
    @align.destroy
    respond_to do |format|
      format.html { redirect_to aligns_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_align
      @align = Align.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def align_params
      params.require(:align).permit(:msa_id, :biosequence_id, :align_rank, :updated_at, :align_sequence)
    end
end
