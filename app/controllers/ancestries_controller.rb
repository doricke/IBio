
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

class AncestriesController < ApplicationController
  before_action :set_ancestry, only: [:show, :edit, :update, :destroy]

  # GET /ancestries
  # GET /ancestries.json
  def index
    @ancestries = Ancestry.where(individual_id: session['individual_id']).to_a
    @ethnics_hash = Tools::to_hash(Ethnic.all)
    @itypes_hash = Tools::to_hash(Itype.all)
  end  # index

  # GET /ancestries/1
  # GET /ancestries/1.json
  def show
  end

  # GET /ancestries/new
  def new
    @ancestry = Ancestry.new
  end

  # GET /ancestries/1/edit
  def edit
  end

  # POST /ancestries
  # POST /ancestries.json
  def create
    @ancestry = Ancestry.new(ancestry_params)

    respond_to do |format|
      if @ancestry.save
        format.html { redirect_to @ancestry, notice: 'Ancestry was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ancestry }
      else
        format.html { render action: 'new' }
        format.json { render json: @ancestry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ancestries/1
  # PATCH/PUT /ancestries/1.json
  def update
    respond_to do |format|
      if @ancestry.update(ancestry_params)
        format.html { redirect_to @ancestry, notice: 'Ancestry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ancestry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ancestries/1
  # DELETE /ancestries/1.json
  def destroy
    @ancestry.destroy
    respond_to do |format|
      format.html { redirect_to ancestries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ancestry
      @ancestry = Ancestry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ancestry_params
      params.require(:ancestry).permit(:individual_id, :ethnic_id, :itype_id, :percent)
    end
end
