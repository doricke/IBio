
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

class SicksController < ApplicationController
  before_action :set_sick, only: [:show, :edit, :update, :destroy]

  # GET /sicks
  # GET /sicks.json
  def index
    @sicks = Sick.where(guid1: session['guid1']).to_a
    @itypes_hash = Tools::to_hash(Itype.where(category: 'sick').order(:name).to_a)
  end  # index

  # GET /sicks/1
  # GET /sicks/1.json
  def show
    @itype = Itype.find(@sick.itype_id) if ! @sick.itype_id.nil?
  end  # show

  # GET /sicks/new
  def new
    @sick = Sick.new
    @itypes = Itype.where(category: 'sick').order(:name).to_a
  end

  # GET /sicks/1/edit
  def edit
    @itypes = Itype.where(category: 'sick').order(:name).to_a
  end

  # POST /sicks
  # POST /sicks.json
  def create
    @sick = Sick.new(sick_params)

    respond_to do |format|
      if @sick.save
        format.html { redirect_to @sick, notice: 'Sick was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sick }
      else
        @itypes = Itype.where(category: 'sick').order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @sick.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sicks/1
  # PATCH/PUT /sicks/1.json
  def update
    respond_to do |format|
      if @sick.update(sick_params)
        format.html { redirect_to @sick, notice: 'Sick was successfully updated.' }
        format.json { head :no_content }
      else
        @itypes = Itype.where(category: 'sick').order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @sick.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sicks/1
  # DELETE /sicks/1.json
  def destroy
    @sick.destroy
    respond_to do |format|
      format.html { redirect_to sicks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sick
      @sick = Sick.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sick_params
      params.require(:sick).permit(:itype_id, :guid1, :start_time, :end_time)
    end
end
