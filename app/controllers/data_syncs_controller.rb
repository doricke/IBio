
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

class DataSyncsController < ApplicationController
  before_action :set_data_sync, only: [:show, :edit, :update, :destroy]

  # GET /data_syncs
  # GET /data_syncs.json
  def index
    @data_syncs = DataSync.all
  end

  # GET /data_syncs/1
  # GET /data_syncs/1.json
  def show
  end

  # GET /data_syncs/new
  def new
    @data_sync = DataSync.new
  end

  # GET /data_syncs/1/edit
  def edit
  end

  # POST /data_syncs
  # POST /data_syncs.json
  def create
    @data_sync = DataSync.new(data_sync_params)

    respond_to do |format|
      if @data_sync.save
        format.html { redirect_to @data_sync, notice: 'Data sync was successfully created.' }
        format.json { render action: 'show', status: :created, location: @data_sync }
      else
        format.html { render action: 'new' }
        format.json { render json: @data_sync.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_syncs/1
  # PATCH/PUT /data_syncs/1.json
  def update
    respond_to do |format|
      if @data_sync.update(data_sync_params)
        format.html { redirect_to @data_sync, notice: 'Data sync was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @data_sync.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_syncs/1
  # DELETE /data_syncs/1.json
  def destroy
    @data_sync.destroy
    respond_to do |format|
      format.html { redirect_to data_syncs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_sync
      @data_sync = DataSync.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_sync_params
      params.require(:data_sync).permit(:individual_id, :instrument_id, :algorithm_id, :updated_at)
    end
end
