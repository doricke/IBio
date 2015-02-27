
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

class MatsController < ApplicationController
  before_action :set_mat, only: [:show, :edit, :update, :destroy]

  # GET /mats
  # GET /mats.json
  def index
    @mats = Mat.where(individual_id: session['individual_id']).to_a
    @attachments_hash = Tools::to_hash(Attachment.find_all_by_individual_id(session['individual_id'], :select => 'id,instrument_id,itype_id,name,content_type,created_at,is_parsed'))
  end  # index

  # GET /mats/1
  # GET /mats/1.json
  def show
  end

  # GET /mats/new
  def new
    @mat = Mat.new
  end

  # GET /mats/1/edit
  def edit
  end

  # POST /mats
  # POST /mats.json
  def create
    @mat = Mat.new(mat_params)

    respond_to do |format|
      if @mat.save
        format.html { redirect_to @mat, notice: 'Mat was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mat }
      else
        format.html { render action: 'new' }
        format.json { render json: @mat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mats/1
  # PATCH/PUT /mats/1.json
  def update
    respond_to do |format|
      if @mat.update(mat_params)
        format.html { redirect_to @mat, notice: 'Mat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mats/1
  # DELETE /mats/1.json
  def destroy
    @mat.destroy
    respond_to do |format|
      format.html { redirect_to mats_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mat
      @mat = Mat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mat_params
      params.require(:mat).permit(:individual_id, :vocal_id, :attachment_id, :algorithm_id, :score, :start_time, :updated_at)
    end
end
