
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

class IeventsController < ApplicationController
  before_action :set_Ievent, only: [:show, :edit, :update, :destroy]

  # GET /Ievents
  # GET /Ievents.json
  def index
    @ievents = Ievent.where(individual_id: session['individual_id']).to_a
    @itypes_hash = Tools::to_hash(Itype.where(category: 'ievent').order(:name).to_a)
  end  # index

  # GET /Ievents/1
  # GET /Ievents/1.json
  def show
    @itype = Itype.find(@ievent.itype_id) if ! @ievent.itype_id.nil?
  end  # show

  # GET /Ievents/new
  def new
    @ievent = Ievent.new
    @itypes = Itype.where(category: 'ievent').order(:name).to_a
  end  # new

  # GET /Ievents/1/edit
  def edit
    @itypes = Itype.where(category: 'ievent').order(:name).to_a
  end  # edit

  # POST /Ievents
  # POST /Ievents.json
  def create
    @ievent = Ievent.new(Ievent_params)

    respond_to do |format|
      if @ievent.save
        format.html { redirect_to @ievent, notice: 'Ievent was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ievent }
      else
        @itypes = Itype.where(category: 'ievent').order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @Ievent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /Ievents/1
  # PATCH/PUT /Ievents/1.json
  def update
    respond_to do |format|
      if @ievent.update(ievent_params)
        format.html { redirect_to @ievent, notice: 'Ievent was successfully updated.' }
        format.json { head :no_content }
      else
        @itypes = Itype.where(category: 'ievent').order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @ievent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Ievents/1
  # DELETE /Ievents/1.json
  def destroy
    @ievent.destroy
    respond_to do |format|
      format.html { redirect_to ievents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ievent
      @ievent = Ievent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ievent_params
      params.require(:Ievent).permit(:individual_id, :activity_id, :itype_id, :name, :start_time, :end_time)
    end
end
