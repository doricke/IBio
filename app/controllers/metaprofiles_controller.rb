
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

class MetaprofilesController < ApplicationController
  before_action :set_metaprofile, only: [:show, :edit, :update, :destroy]

  # GET /metaprofiles
  # GET /metaprofiles.json
  def index
    @metaprofiles = Metaprofile.all
  end

  # GET /metaprofiles/1
  # GET /metaprofiles/1.json
  def show
  end

  # GET /metaprofiles/new
  def new
    @metaprofile = Metaprofile.new
  end

  # GET /metaprofiles/1/edit
  def edit
  end

  # POST /metaprofiles
  # POST /metaprofiles.json
  def create
    @metaprofile = Metaprofile.new(metaprofile_params)

    respond_to do |format|
      if @metaprofile.save
        format.html { redirect_to @metaprofile, notice: 'Metaprofile was successfully created.' }
        format.json { render action: 'show', status: :created, location: @metaprofile }
      else
        format.html { render action: 'new' }
        format.json { render json: @metaprofile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /metaprofiles/1
  # PATCH/PUT /metaprofiles/1.json
  def update
    respond_to do |format|
      if @metaprofile.update(metaprofile_params)
        format.html { redirect_to @metaprofile, notice: 'Metaprofile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @metaprofile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metaprofiles/1
  # DELETE /metaprofiles/1.json
  def destroy
    @metaprofile.destroy
    respond_to do |format|
      format.html { redirect_to metaprofiles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metaprofile
      @metaprofile = Metaprofile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metaprofile_params
      params.require(:metaprofile).permit(:organism_id, :guid1, :count, :measured_at)
    end
end
