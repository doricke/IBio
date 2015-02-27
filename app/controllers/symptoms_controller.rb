
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

class SymptomsController < ApplicationController
  before_action :set_symptom, only: [:show, :edit, :update, :destroy]

  # GET /symptoms
  # GET /symptoms.json
  def index
    @symptoms = Symptom.where(true).to_a
  end

  # GET /symptoms/1
  # GET /symptoms/1.json
  def show
  end

  # GET /symptoms/new
  def new
    @symptom = Symptom.new
  end

  # GET /symptoms/1/edit
  def edit
  end

  # POST /symptoms
  # POST /symptoms.json
  def create
    @symptom = Symptom.new(symptom_params)

    respond_to do |format|
      if @symptom.save
        format.html { redirect_to @symptom, notice: 'Symptom was successfully created.' }
        format.json { render action: 'show', status: :created, location: @symptom }
      else
        format.html { render action: 'new' }
        format.json { render json: @symptom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /symptoms/1
  # PATCH/PUT /symptoms/1.json
  def update
    respond_to do |format|
      if @symptom.update(symptom_params)
        format.html { redirect_to @symptom, notice: 'Symptom was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @symptom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /symptoms/1
  # DELETE /symptoms/1.json
  def destroy
    @symptom.destroy
    respond_to do |format|
      format.html { redirect_to symptoms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_symptom
      @symptom = Symptom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def symptom_params
      params.require(:symptom).permit(:name)
    end
end
