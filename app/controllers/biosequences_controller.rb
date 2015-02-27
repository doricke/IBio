
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

class BiosequencesController < ApplicationController
  before_action :set_biosequence, only: [:show, :edit, :update, :destroy]

  #############################################################################
  # GET /biosequences
  # GET /biosequences.json
  def index
    @biosequences = Hash[Biosequence.pluck(:id, :name)]
  end

  #############################################################################
  # GET /biosequences/1
  # GET /biosequences/1.json
  def show
    puts "BiosequencesController.show called"
    # @source = Source.find(@biosequence.source_id)
    @sequence_domains = BiosequenceDomain.where(biosequence_id: @biosequence.id).order(:seq_start).to_a
    @variants = Variant.where(biosequence_id: @biosequence.id).order(:sequence_start).to_a
    @structure_sequences = StructureSequence.where(biosequence_id: @biosequence.id).to_a
    @gene = Gene.find(@biosequence.gene_id)
    @structures = {}
    @residues = {}
    if @structure_sequences.size > 0
      @structure_sequences.each do |structure_sequence|
        # @structures[ structure_sequence.structure_id ] = Structure.find(structure_sequence.structure_id, :select => 'id,name') if @structures[ structure_sequence.structure_id ].nil?
        @structures[ structure_sequence.structure_id ] = Structure.where(id: structure_sequence.structure_id).pluck(:id, :name)[0] if @structures[ structure_sequence.structure_id ].nil?
      end  # do

      str_id = params[:str_id] || @structure_sequences[0].structure_id
      # puts "####### str_id: #{str_id}"
      @structure = Structure.find(str_id)
      atoms = Atom.where(structure_id: str_id).to_a
      atoms.each do |aa|
          # @residues[ aa.aa_residue ] = "atomno >= #{aa.atom_start} and atomno <= #{aa.atom_end}" if ! aa.aa_residue.nil?
        selector_name = aa.aa_name.sub(/^(\d+)([A-Z]+)$/, '\1^\2') + ':' + aa.chain
        @residues[ aa.aa_residue ] = [selector_name, 1]
      end  # do
      
      conservation_hash = Hash[Conservation.where(biosequence_id: @biosequence.id).pluck(:position, :level)]
      atoms.each do |aa|
        if conservation_hash.has_key?(aa.aa_residue)
          selector_name = aa.aa_name.sub(/^(\d+)([A-Z]+)$/, '\1^\2') + ':' + aa.chain
          @residues[ aa.aa_residue ] = [selector_name, conservation_hash[aa.aa_residue]]
        end  # if
      end  # do
    else
      @structure = nil
    end  # if
    
    gon.residues = @residues
    # gon.conservations = Hash[Conservation.where(biosequence_id: @biosequence.id).pluck(:position, :level)]
  end  # show

  #############################################################################
  # GET /biosequences/new
  def new
    @biosequence = Biosequence.new
  end  # new

  #############################################################################
  # GET /biosequences/1/edit
  def edit
  end  # edit

  #############################################################################
  # POST /biosequences
  # POST /biosequences.json
  def create
    @biosequence = Biosequence.new(biosequence_params)

    respond_to do |format|
      if @biosequence.save
        format.html { redirect_to @biosequence, notice: 'Biosequence was successfully created.' }
        format.json { render action: 'show', status: :created, location: @biosequence }
      else
        format.html { render action: 'new' }
        format.json { render json: @biosequence.errors, status: :unprocessable_entity }
      end
    end
  end

  #############################################################################
  # PATCH/PUT /biosequences/1
  # PATCH/PUT /biosequences/1.json
  def update
    respond_to do |format|
      if @biosequence.update(biosequence_params)
        format.html { redirect_to @biosequence, notice: 'Biosequence was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @biosequence.errors, status: :unprocessable_entity }
      end
    end
  end

  #############################################################################
  # DELETE /biosequences/1
  # DELETE /biosequences/1.json
  def destroy
    @biosequence.destroy
    respond_to do |format|
      format.html { redirect_to biosequences_url }
      format.json { head :no_content }
    end
  end
  
  #############################################################################
  def get_pdb
    # puts "####### Looking for #{params[:id]} #######"
    @structure = Structure.find(params[:id])
    send_data(@structure.pdb, :type => 'text/plain', :disposition => 'inline')
  end  # get_pdb

  private
  #############################################################################
    # Use callbacks to share common setup or constraints between actions.
    def set_biosequence
      @biosequence = Biosequence.find(params[:id])
    end

#############################################################################
    # Never trust parameters from the scary internet, only allow the white list through.
    def biosequence_params
      params.require(:biosequence).permit(:source_id, :gene_id, :organism_id, :name, :copy_number, :exons, :aa_sequence, :mrna_sequence, :updated_at, :str_id)
    end

#############################################################################

end  # class
