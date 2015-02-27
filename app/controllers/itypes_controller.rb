
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

class ItypesController < ApplicationController
  before_action :set_type, only: [:show, :edit, :update, :destroy]

  # GET /itypes
  # GET /itypes.json
  def index
    @itypes = Itype.all
    @units_hash = Tools::to_hash(Unit.all)
  end  # index

  # GET /itypes/1
  # GET /itypes/1.json
  def show
    @unit = Unit.where(id: @itype.unit_id).take if ! @itype.unit_id.nil?
  end

  # GET /itypes/new
  def new
    @itype = Itype.new
  end

  # GET /itypes/1/edit
  def edit
    @units = Unit.all
  end  # edit

  # POST /itypes
  # POST /itypes.json
  def create
    @itype = Itype.new(itype_params)

    respond_to do |format|
      if @itype.save
        format.html { redirect_to @itype, notice: 'Itype was successfully created.' }
        format.json { render action: 'show', status: :created, location: @itype }
      else
        format.html { render action: 'new' }
        format.json { render json: @itype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /itypes/1
  # PATCH/PUT /itypes/1.json
  def update
    respond_to do |format|
      if @itype.update(itype_params)
        format.html { redirect_to @itype, notice: 'Itype was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @itype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /itypes/1
  # DELETE /itypes/1.json
  def destroy
    @itype.destroy
    respond_to do |format|
      format.html { redirect_to itypes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @itype = Itype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def itype_params
      params.require(:itype).permit(:name, :category, :unit_id)
    end
end
