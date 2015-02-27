
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

class EthnicsController < ApplicationController
  before_action :set_ethnic, only: [:show, :edit, :update, :destroy]

  # GET /ethnics
  # GET /ethnics.json
  def index
    @ethnics = Ethnic.all
  end

  # GET /ethnics/1
  # GET /ethnics/1.json
  def show
  end

  # GET /ethnics/new
  def new
    @ethnic = Ethnic.new
  end

  # GET /ethnics/1/edit
  def edit
  end

  # POST /ethnics
  # POST /ethnics.json
  def create
    @ethnic = Ethnic.new(ethnic_params)

    respond_to do |format|
      if @ethnic.save
        format.html { redirect_to @ethnic, notice: 'Ethnic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ethnic }
      else
        format.html { render action: 'new' }
        format.json { render json: @ethnic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ethnics/1
  # PATCH/PUT /ethnics/1.json
  def update
    respond_to do |format|
      if @ethnic.update(ethnic_params)
        format.html { redirect_to @ethnic, notice: 'Ethnic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ethnic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ethnics/1
  # DELETE /ethnics/1.json
  def destroy
    @ethnic.destroy
    respond_to do |format|
      format.html { redirect_to ethnics_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ethnic
      @ethnic = Ethnic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ethnic_params
      params.require(:ethnic).permit(:name, :race, :region)
    end
end
