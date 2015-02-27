
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

class AttributesController < ApplicationController
  before_action :set_attribute, only: [:show, :edit, :update, :destroy]

  # GET /attributes
  # GET /attributes.json
  def index
    @attributes = Attribute.where(individual_id: session['individual_id']).to_a
    @units_hash = Tools::to_hash(Unit.all)
  end  # index

  # GET /attributes/1
  # GET /attributes/1.json
  def show
    @unit = Unit.find(@attribute.unit_id)
  end

  # GET /attributes/new
  def new
    @attribute = Attribute.new
    @units = Unit.order(:name).to_a
  end

  # GET /attributes/1/edit
  def edit
    @units = Unit.order(:name).to_a
  end

  # POST /attributes
  # POST /attributes.json
  def create
    @attribute = Attribute.new(attribute_params)
    @attribute.individual_id = session[:individual_id]

    respond_to do |format|
      if @attribute.save
        format.html { redirect_to @attribute, notice: 'Attribute was successfully created.' }
        format.json { render action: 'show', status: :created, location: @attribute }
      else
        @units = Unit.order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attributes/1
  # PATCH/PUT /attributes/1.json
  def update
    respond_to do |format|
      if @attribute.update(attribute_params)
        format.html { redirect_to @attribute, notice: 'Attribute was successfully updated.' }
        format.json { head :no_content }
      else
        @units = Unit.order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attributes/1
  # DELETE /attributes/1.json
  def destroy
    @attribute.destroy
    respond_to do |format|
      format.html { redirect_to attributes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attribute
      @attribute = Attribute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attribute_params
      params.require(:attribute).permit(:individual_id, :unit_id, :name, :category, :amount, :measured_at)
    end
end
