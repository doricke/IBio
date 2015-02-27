
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

class EpochesController < ApplicationController
  before_action :set_epoch, only: [:show, :edit, :update, :destroy]

  # GET /epoches
  # GET /epoches.json
  def index
    @epoches = Epoch.all
  end

  # GET /epoches/1
  # GET /epoches/1.json
  def show
  end

  # GET /epoches/new
  def new
    @epoch = Epoch.new
  end

  # GET /epoches/1/edit
  def edit
  end

  # POST /epoches
  # POST /epoches.json
  def create
    @epoch = Epoch.new(epoch_params)

    respond_to do |format|
      if @epoch.save
        format.html { redirect_to @epoch, notice: 'Epoch was successfully created.' }
        format.json { render action: 'show', status: :created, location: @epoch }
      else
        format.html { render action: 'new' }
        format.json { render json: @epoch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /epoches/1
  # PATCH/PUT /epoches/1.json
  def update
    respond_to do |format|
      if @epoch.update(epoch_params)
        format.html { redirect_to @epoch, notice: 'Epoch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @epoch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /epoches/1
  # DELETE /epoches/1.json
  def destroy
    @epoch.destroy
    respond_to do |format|
      format.html { redirect_to epoches_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epoch
      @epoch = Epoch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def epoch_params
      params.require(:epoch).permit(:year, :month, :day, :hour, :minute, :second, :usec)
    end
end
