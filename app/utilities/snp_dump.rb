require 'output_file.rb'

class SnpDump

  def dump_snps
    snp_type = Itype.where(name: "23andMe").take
    return if snp_type.nil?
    
    attachments = Attachment.where(itype_id: snp_type.id).to_a
    attachments.each do |attachment|
      out = OutputFile.new( attachment.name )
      puts "Writing #{attachment.name}"
      out.open_file
      out.write( attachment.file_text )
      out.close_file
    end  # do
    
  end  # dump_snps

end  # class

def main_method
  app = SnpDump.new
  app.dump_snps
end  # main_method

main_method