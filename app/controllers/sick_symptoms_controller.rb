
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

class SickSymptomsController < ApplicationController
  before_action :set_sick_symptom, only: [:show, :edit, :update, :destroy]

  # GET /sick_symptoms
  # GET /sick_symptoms.json
  def index
    @sick_symptoms = SickSymptom.where(true).to_a
    @symptoms_hash = Tools::to_hash(Symptom.order(:name).to_a)
  end

  # GET /sick_symptoms/1
  # GET /sick_symptoms/1.json
  def show
    @symptom = Symptom.find(@sick_symptom.symptom_id) if ! @sick_symptom.symptom_id.nil?
  end

  # GET /sick_symptoms/new
  def new
    @sick_symptom = SickSymptom.new
    @symptoms = Symptom.order(:name).to_a
  end

  # GET /sick_symptoms/1/edit
  def edit
    @symptoms = Symptom.order(:name).to_a
  end

  # POST /sick_symptoms
  # POST /sick_symptoms.json
  def create
    @sick_symptom = SickSymptom.new(sick_symptom_params)

    respond_to do |format|
      if @sick_symptom.save
        format.html { redirect_to @sick_symptom, notice: 'Sick symptom was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sick_symptom }
      else
        @symptoms = Symptom.order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @sick_symptom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sick_symptoms/1
  # PATCH/PUT /sick_symptoms/1.json
  def update
    respond_to do |format|
      if @sick_symptom.update(sick_symptom_params)
        format.html { redirect_to @sick_symptom, notice: 'Sick symptom was successfully updated.' }
        format.json { head :no_content }
      else
        @symptoms = Symptom.order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @sick_symptom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sick_symptoms/1
  # DELETE /sick_symptoms/1.json
  def destroy
    @sick_symptom.destroy
    respond_to do |format|
      format.html { redirect_to sick_symptoms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sick_symptom
      @sick_symptom = SickSymptom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sick_symptom_params
      params.require(:sick_symptom).permit(:sick_id, :symptom_id, :guid1, :start_time, :end_time, :measurement)
    end
end
