
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

class PrescriptionsController < ApplicationController
  before_action :set_prescription, only: [:show, :edit, :update, :destroy]

  # GET /prescriptions
  # GET /prescriptions.json
  def index
    @prescriptions = Prescription.where(guid1: session['guid1']).to_a
    @drugs_hash = Tools::to_hash(Drug.all)
    @units_hash = Tools::to_hash(Unit.all)
  end  # index

  # GET /prescriptions/1
  # GET /prescriptions/1.json
  def show
    @unit = Unit.find(@prescription.unit_it)
    @drug = Drug.find(@prescription.drug_id)
  end  # show

  # GET /prescriptions/new
  def new
    @prescription = Prescription.new
    @units = Unit.order(:name).to_a
    @drugs = Drug.order(:name).to_a
  end  # new

  # GET /prescriptions/1/edit
  def edit
    @units = Unit.order(:name).to_a
    @drugs = Drug.order(:name).to_a
  end

  # POST /prescriptions
  # POST /prescriptions.json
  def create
    @prescription = Prescription.new(prescription_params)
    @prescription.guid1 = session[:guid1]

    respond_to do |format|
      if @prescription.save
        format.html { redirect_to @prescription, notice: 'Prescription was successfully created.' }
        format.json { render action: 'show', status: :created, location: @prescription }
      else
        @units = Unit.order(:name).to_a
        @drugs = Drug.order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prescriptions/1
  # PATCH/PUT /prescriptions/1.json
  def update
    respond_to do |format|
      if @prescription.update(prescription_params)
        format.html { redirect_to @prescription, notice: 'Prescription was successfully updated.' }
        format.json { head :no_content }
      else
        @units = Unit.order(:name).to_a
        @drugs = Drug.order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prescriptions/1
  # DELETE /prescriptions/1.json
  def destroy
    @prescription.destroy
    respond_to do |format|
      format.html { redirect_to prescriptions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prescription
      @prescription = Prescription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prescription_params
      params.require(:prescription).permit(:drug_id, :unit_it, :guid1, :dose, :daily, :start_time, :end_time)
    end
end
