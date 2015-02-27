
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

class BiosequenceDomainsController < ApplicationController
  before_action :set_biosequence_domain, only: [:show, :edit, :update, :destroy]

  # GET /biosequence_domains
  # GET /biosequence_domains.json
  def index
    @biosequence_domains = BiosequenceDomain.all
  end

  # GET /biosequence_domains/1
  # GET /biosequence_domains/1.json
  def show
  end

  # GET /biosequence_domains/new
  def new
    @biosequence_domain = BiosequenceDomain.new
  end

  # GET /biosequence_domains/1/edit
  def edit
  end

  # POST /biosequence_domains
  # POST /biosequence_domains.json
  def create
    @biosequence_domain = BiosequenceDomain.new(biosequence_domain_params)

    respond_to do |format|
      if @biosequence_domain.save
        format.html { redirect_to @biosequence_domain, notice: 'Biosequence domain was successfully created.' }
        format.json { render action: 'show', status: :created, location: @biosequence_domain }
      else
        format.html { render action: 'new' }
        format.json { render json: @biosequence_domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /biosequence_domains/1
  # PATCH/PUT /biosequence_domains/1.json
  def update
    respond_to do |format|
      if @biosequence_domain.update(biosequence_domain_params)
        format.html { redirect_to @biosequence_domain, notice: 'Biosequence domain was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @biosequence_domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /biosequence_domains/1
  # DELETE /biosequence_domains/1.json
  def destroy
    @biosequence_domain.destroy
    respond_to do |format|
      format.html { redirect_to biosequence_domains_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_biosequence_domain
      @biosequence_domain = BiosequenceDomain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def biosequence_domain_params
      params.require(:biosequence_domain).permit(:biosequence_id, :domain_id, :seq_start, :seq_end)
    end
end
