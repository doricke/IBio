
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

class AirsController < ApplicationController
  before_action :set_air, only: [:show, :edit, :update, :destroy]

  # GET /airs
  # GET /airs.json
  def index
    @airs = Air.where(true).to_a
    @places_hash = Tools::to_hash(Place.where(true).to_a)
    @itypes_hash = Tools::to_hash(Itype.where(category: 'Air').to_a)
  end  # index

  # GET /airs/1
  # GET /airs/1.json
  def show
  end

  # GET /airs/new
  def new
    @air = Air.new
  end

  # GET /airs/1/edit
  def edit
  end

  # POST /airs
  # POST /airs.json
  def create
    @air = Air.new(air_params)

    respond_to do |format|
      if @air.save
        format.html { redirect_to @air, notice: 'Air was successfully created.' }
        format.json { render action: 'show', status: :created, location: @air }
      else
        format.html { render action: 'new' }
        format.json { render json: @air.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /airs/1
  # PATCH/PUT /airs/1.json
  def update
    respond_to do |format|
      if @air.update(air_params)
        format.html { redirect_to @air, notice: 'Air was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @air.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /airs/1
  # DELETE /airs/1.json
  def destroy
    @air.destroy
    respond_to do |format|
      format.html { redirect_to airs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_air
      @air = Air.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def air_params
      params.require(:air).permit(:itype_id, :place_id, :air_value, :sampled_at)
    end
end
