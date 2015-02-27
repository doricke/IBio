
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

class DataRangesController < ApplicationController
  before_action :set_data_range, only: [:show, :edit, :update, :destroy]

  # GET /data_ranges
  # GET /data_ranges.json
  def index
    @data_ranges = DataRange.all
  end

  # GET /data_ranges/1
  # GET /data_ranges/1.json
  def show
  end

  # GET /data_ranges/new
  def new
    @data_range = DataRange.new
  end

  # GET /data_ranges/1/edit
  def edit
  end

  # POST /data_ranges
  # POST /data_ranges.json
  def create
    @data_range = DataRange.new(data_range_params)

    respond_to do |format|
      if @data_range.save
        format.html { redirect_to @data_range, notice: 'Data range was successfully created.' }
        format.json { render action: 'show', status: :created, location: @data_range }
      else
        format.html { render action: 'new' }
        format.json { render json: @data_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_ranges/1
  # PATCH/PUT /data_ranges/1.json
  def update
    respond_to do |format|
      if @data_range.update(data_range_params)
        format.html { redirect_to @data_range, notice: 'Data range was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @data_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_ranges/1
  # DELETE /data_ranges/1.json
  def destroy
    @data_range.destroy
    respond_to do |format|
      format.html { redirect_to data_ranges_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_range
      @data_range = DataRange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_range_params
      params.require(:data_range).permit(:itype_id, :table_name, :lower, :upper, :qualifier, :description)
    end
end
