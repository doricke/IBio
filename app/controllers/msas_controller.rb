
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

class MsasController < ApplicationController
  before_action :set_msa, only: [:show, :edit, :update, :destroy]

  # GET /msas
  # GET /msas.json
  def index
    @msas = Msa.all
  end

  # GET /msas/1
  # GET /msas/1.json
  def show
  end

  # GET /msas/new
  def new
    @msa = Msa.new
  end

  # GET /msas/1/edit
  def edit
  end

  # POST /msas
  # POST /msas.json
  def create
    @msa = Msa.new(msa_params)

    respond_to do |format|
      if @msa.save
        format.html { redirect_to @msa, notice: 'Msa was successfully created.' }
        format.json { render action: 'show', status: :created, location: @msa }
      else
        format.html { render action: 'new' }
        format.json { render json: @msa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /msas/1
  # PATCH/PUT /msas/1.json
  def update
    respond_to do |format|
      if @msa.update(msa_params)
        format.html { redirect_to @msa, notice: 'Msa was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @msa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /msas/1
  # DELETE /msas/1.json
  def destroy
    @msa.destroy
    respond_to do |format|
      format.html { redirect_to msas_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_msa
      @msa = Msa.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def msa_params
      params.require(:msa).permit(:gene_id, :name, :category, :description, :msa_type, :updated_at)
    end
end
