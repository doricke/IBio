
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

class OrganismsController < ApplicationController
  before_action :set_organism, only: [:show, :edit, :update, :destroy]

  # GET /organisms
  # GET /organisms.json
  def index
    @organisms = Organism.all
  end

  # GET /organisms/1
  # GET /organisms/1.json
  def show
  end

  # GET /organisms/new
  def new
    @organism = Organism.new
  end

  # GET /organisms/1/edit
  def edit
  end

  # POST /organisms
  # POST /organisms.json
  def create
    @organism = Organism.new(organism_params)

    respond_to do |format|
      if @organism.save
        format.html { redirect_to @organism, notice: 'Organism was successfully created.' }
        format.json { render action: 'show', status: :created, location: @organism }
      else
        format.html { render action: 'new' }
        format.json { render json: @organism.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organisms/1
  # PATCH/PUT /organisms/1.json
  def update
    respond_to do |format|
      if @organism.update(organism_params)
        format.html { redirect_to @organism, notice: 'Organism was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @organism.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organisms/1
  # DELETE /organisms/1.json
  def destroy
    @organism.destroy
    respond_to do |format|
      format.html { redirect_to organisms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organism
      @organism = Organism.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organism_params
      params.require(:organism).permit(:name, :taxonomy, :genus, :species)
    end
end
