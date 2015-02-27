
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

class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:show, :edit, :update, :download, :show_image, :destroy, :fileupload]
  skip_before_filter :verify_authenticity_token, :drop_form

#############################################################################
  # GET /attachments
  # GET /attachments.json
  def index
    # @attachments = Attachment.getNames(session['individual_id'])
    @attachments = Attachment.find_all_by_individual_id(session['individual_id'],
      :select => 'id,instrument_id,itype_id,name,content_type,created_at,is_parsed')
    @instruments = Instrument.where(instrument_type: 'Health Monitor').order(:name).to_a
    @instruments_hash = Tools::to_hash(Instrument.all)
    @itypes_hash = Tools::to_hash(Itype.all)
  end  # index

#############################################################################
  # GET /attachments/1
  # GET /attachments/1.json
  def show
    @itype = Itype.find(@attachment.itype_id) if ! @attachment.itype_id.nil?
  end  # show

#############################################################################
  # GET /attachments/new
  def new
    puts "*** attachments.new params: #{params}"
    
    @attachment = Attachment.new
    @instruments = Instrument.where(instrument_type: 'Health Monitor').order(:name).to_a
    @itypes = Itype.where(category: 'attachment').to_a
    puts "#### instruments: #{@instruments}"
  end  # new

#############################################################################
  # GET /attachments/1/edit
  def edit
    @instruments = Instrument.where(instrument_type: 'Health Monitor').order(:name).to_a
  end

#############################################################################
  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.individual_id = session[:individual_id]

    respond_to do |format|
      if @attachment.save
        @attachment.parse_file( session[:guid2], @attachment.id )
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @attachment }
      else
        @instruments = Instrument.where(instrument_type: 'Health Monitor').order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #############################################################################
  def basis
    puts "**** basis: #{params}"
    @device = params[:data][:device]
    puts "**** device: #{@device}"
  end  # basis
  
  #############################################################################
  def basis_load
    puts "###### basis_load: params: #{params}"
    device = params[:device]
    puts "**** device: #{device}"
    email_name = params[:email_name]
    pw = params[:password]
    date_start = Tools::paramDate( params[:date_start] )
    date_end = Tools::paramDate( params[:date_end] )
    basis_loader = BasisLoader.new
    basis_loader.basisSync( session[:individual_id], email_name, pw, date_start, date_end, device )
    
    redirect_to attachments_path
  end  # basis_load
  
  #############################################################################
  def zap
    @attachment = Attachment.new
    puts "####### params: #{params}"
  end  # zap
  
  #############################################################################
  def zap2
    @attachment = Attachment.new
    puts "####### zap2 ***** params: #{params}"
  end  # zap2
  
  #############################################################################
  # POST /attachments
  # POST /attachments.json
  def fileupload
    puts "######### fileupload; params: #{params}"
    @attachment = Attachment.new(attachment_params)
    @attachment.individual_id = session[:individual_id]
    
    respond_to do |format|
      if @attachment.save
        @attachment.parse_file( session[:guid2], @attachment.id )
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @attachment }
        else
        @instruments = Instrument.where(instrument_type: 'Health Monitor').order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end  # method fileupload

#############################################################################
  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment, notice: 'Attachment was successfully updated.' }
        format.json { head :no_content }
      else
        @instruments = Instrument.where(instrument_type: 'Health Monitor').order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to attachments_url }
      format.json { head :no_content }
    end
  end
  
  #############################################################################
  def download
    send_data @attachment.file_binary, :filename => @attachment.name, :type => @attachment.content_type
  end  # download
  
  #############################################################################
  def show_image
    send_data(@attachment.file_binary, :type => @attachment.content_type, :disposition => 'inline')
  end  # show_image

#############################################################################
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
        @attachment = Attachment.find(params[:id]) if params[:id] != "basis"
    end

#############################################################################
    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:individual_id, :instrument_id, :itype_id, :name, :content_type, :file_path, :created_at, :file_text, :file_binary, :is_parsed, :datafile)
    end

#############################################################################

end
