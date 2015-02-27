
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

class GosController < ApplicationController
  before_action :set_go, only: [:show, :edit, :update, :destroy]

  # GET /gos
  # GET /gos.json
  def index
    @gos = Go.all
  end

  # GET /gos/1
  # GET /gos/1.json
  def show
  end

  # GET /gos/new
  def new
    @go = Go.new
  end

  # GET /gos/1/edit
  def edit
  end

  # POST /gos
  # POST /gos.json
  def create
    @go = Go.new(go_params)

    respond_to do |format|
      if @go.save
        format.html { redirect_to @go, notice: 'Go was successfully created.' }
        format.json { render action: 'show', status: :created, location: @go }
      else
        format.html { render action: 'new' }
        format.json { render json: @go.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gos/1
  # PATCH/PUT /gos/1.json
  def update
    respond_to do |format|
      if @go.update(go_params)
        format.html { redirect_to @go, notice: 'Go was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @go.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gos/1
  # DELETE /gos/1.json
  def destroy
    @go.destroy
    respond_to do |format|
      format.html { redirect_to gos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_go
      @go = Go.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def go_params
      params.require(:go).permit(:gene_id, :itype_id, :term, :pubmed)
    end
end
