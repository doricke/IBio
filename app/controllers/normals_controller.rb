
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

class NormalsController < ApplicationController
  before_action :set_normal, only: [:show, :edit, :update, :destroy]

  # GET /normals
  # GET /normals.json
  def index
    @normals = Normal.where(true).to_a
    @itypes_hash = Tools::to_hash(Itype.order(:name).to_a)
 end  # index

  # GET /normals/1
  # GET /normals/1.json
  def show
    @itype = Itype.find(@normal.itype_id) if ! @normal.itype_id.nil?
  end

  # GET /normals/new
  def new
    @normal = Normal.new
    @itypes = Itype.order(:name).to_a
  end

  # GET /normals/1/edit
  def edit
    @itypes = Itype.order(:name).to_a
  end

  # POST /normals
  # POST /normals.json
  def create
    @normal = Normal.new(normal_params)

    respond_to do |format|
      if @normal.save
        format.html { redirect_to @normal, notice: 'Normal was successfully created.' }
        format.json { render action: 'show', status: :created, location: @normal }
      else
        @itypes = Itype.order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @normal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /normals/1
  # PATCH/PUT /normals/1.json
  def update
    respond_to do |format|
      if @normal.update(normal_params)
        format.html { redirect_to @normal, notice: 'Normal was successfully updated.' }
        format.json { head :no_content }
      else
        @itypes = Itype.order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @normal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /normals/1
  # DELETE /normals/1.json
  def destroy
    @normal.destroy
    respond_to do |format|
      format.html { redirect_to normals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_normal
      @normal = Normal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def normal_params
      params.require(:normal).permit(:ethnic_id, :note_id, :normal_low, :normal_high, :ref_range, :sex, :age_low, :age_high)
    end
end
