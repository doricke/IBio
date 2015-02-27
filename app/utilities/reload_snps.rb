require 'input_file.rb'

################################################################################
# Copyright (C) 2015  Darrell O. Ricke, PhD
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

class ReloadSnps
  
  ###############################################################################
  def reload_snps()
    itype = Itype.where(name: "23andMe" ).take
    attachments = Attachment.where( itype_id: itype.id ).to_a
    individuals_hash = Tools::to_hash( Individual.all )
    snps_loader = SnpsLoader.new
    attachments.each do |attachment|
      individual_id = attachment.individual_id
      puts "Processing: #{individual_id} file #{attachment.name}"
      guid2 = individuals_hash[ individual_id ].guid2
      snps_loader.load_contents( attachment.file_text, guid2, individual_id, attachment.instrument_id, itype.id, attachment.name, attachment.id )
    end  # do
  end  # reload_snps
end #class

###############################################################################

def main_method
  app = ReloadSnps.new
  app.reload_snps()
end  # main_method

###############################################################################

main_method
